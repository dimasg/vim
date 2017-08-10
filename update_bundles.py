#!/usr/bin/env python3
"""Script for vim plugins update"""

# ruby original:
# http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen

import argparse
import json
import os
import shutil
import stat
import sys
import urllib.request
import zipfile

import jsmin


# from http://stackoverflow.com/questions/1889597/deleting-directory-in-python
def remove_readonly(file_name, path, _):
    """removed read-only entity"""
    if file_name is os.rmdir:
        for root, dirs, files in os.walk(path, topdown=False):
            for name in files:
                path_name = os.path.join(root, name)
                os.chmod(path_name, stat.S_IWRITE)
                os.remove(path_name)
            for name in dirs:
                path_name = os.path.join(root, name)
                os.chmod(path_name, stat.S_IWRITE)
                os.rmdir(path_name)
    elif file_name is os.remove:
        os.chmod(path, stat.S_IWRITE)
        os.remove(path)


def backup_dir(dir_name, backup_dir_name):
    """ backup dir """
    if os.path.exists(backup_dir_name):
        print('{0} already exists, remove it first!'.format(backup_dir_name))
        exit(2)
    if os.path.exists(dir_name):
        os.rename(dir_name, backup_dir_name)


def get_url_plugin(plugin, getter, to_dir):
    """ load 'url' plugin """
    if 'no_sub_dirs' in plugin:
        local_dir = to_dir
    else:
        to_dir = os.path.join(to_dir, plugin['name'])
        local_dir = os.path.join(to_dir, plugin['type'])
        os.makedirs(local_dir)
    local_file_name = os.path.join(
        local_dir,
        '{0}.{1}'.format(plugin['name'], plugin['ext'])
    )

    try:
        print('Downloading {0} to {1}'.format(plugin['name'], local_dir))
        url = getter['url'].format(plugin['url'])
        remote_file = urllib.request.urlopen(url)
        fileflags = 'w'
        if plugin['type'] != 'vim':
            fileflags += 'b'
        local_file = open(local_file_name, fileflags)
        local_file.write(remote_file.read())
        local_file.close()
    except urllib.request.HTTPError as exc:
        print('HTTPError: code={0}, url={1}'.format(exc.code, url))
        return 0
    except urllib.error.URLError as exc:
        print('URLError: code={0}, url={1}'.format(exc.errno, url))
        return 0

    if 'extract' in plugin:
        if not zipfile.is_zipfile(local_file_name):
            print('{0} is not valid zip file!'.format(local_file_name))
        else:
            local_dir = to_dir
            if plugin['extract'] != '':
                local_dir = os.path.join(local_dir, plugin['extract'])
            print('Extracting {0} to {1}'.format(local_file_name, local_dir))
            zip_file = zipfile.ZipFile(local_file_name, 'r')
            zip_file.extractall(local_dir)

    return 1


def get_run_plugin(plugin, getter, to_dir):
    """ load 'run' plugin """
    next_name = plugin['url'].split('/')[-1]
    if next_name.find('.') >= 0:
        next_name = next_name.rpartition('.')[0]
    if next_name is None or next_name == '':
        print('{0} parsing name error'.format(plugin['url']))
        exit(4)
    if 'no_sub_dirs' not in plugin:
        to_dir = os.path.join(to_dir, next_name)
        if 'type' in plugin:
            to_dir = os.path.join(to_dir, plugin['type'])
        os.makedirs(to_dir)
    print('Unpacking {0} to {1}'.format(plugin['url'], to_dir))
    print(
        getter['run'].format(
            plugin['url'], to_dir, plugin['ver'] if 'ver' in plugin else ''
        )
    )
    exec_res = os.system(
        getter['run'].format(
            plugin['url'], to_dir, plugin['ver'] if 'ver' in plugin else ''
        )
    )
    if exec_res != 0:
        return 0

    if 'remove_dir' in getter:
        shutil.rmtree(
            os.path.join(to_dir, getter['remove_dir']),
            onerror=remove_readonly
        )
    if 'no_sub_dirs' in plugin:
        dest_dir = os.path.join(to_dir, plugin['dest'])
        if os.path.exists(dest_dir):
            for file_name in os.listdir(dest_dir):
                shutil.copy(os.path.join(dest_dir, file_name), to_dir)
            shutil.rmtree(dest_dir)

    return 1


def get_plugin(plugin, getter, to_dir):
    """ load plugin to to_dir via getter """
    if 'url' in getter:
        return get_url_plugin(plugin, getter, to_dir)
    elif 'run' in getter:
        return get_run_plugin(plugin, getter, to_dir)
    else:
        print('Unknown getter type: {0}'.format(plugin['type']))
        return 0


def remove_backup(vim_dir, conf, backup_set):
    """remove backup set"""

    while len(backup_set) > 0:
        next_dir = os.path.join(vim_dir, backup_set.pop())
        next_old_dir = next_dir + conf['old_dir_pfx']
        if os.path.exists(next_old_dir):
            print('Removing old backup dir {0}'.format(next_old_dir))
            shutil.rmtree(next_old_dir, onerror=remove_readonly)
        if os.path.exists(next_dir):
            print('Renaming old dir {0} to backup {1}'.format(next_dir, next_old_dir))
            os.rename(next_dir, next_old_dir)
        next_new_dir = next_dir + conf['new_dir_pfx']
        if os.path.exists(next_new_dir):
            print('Renaming new dir {0} to current {1}'.format(next_new_dir, next_dir))
            os.rename(next_new_dir, next_dir)


def get_vim_plugins(cmd_args):
    """load all vim plugins"""
    vim_dir = ''

    if sys.platform == 'win32':
        vim_dir = os.path.expanduser("~/vimfiles")
    else:
        vim_dir = os.path.expanduser("~/.vim")

    conf = None
    with open('plugins.cfg', 'r') as file:
        conf = json.loads(jsmin.jsmin(file.read()))

    backup_set = set()

    for next_plugin in conf['plugins']:
        next_dir = os.path.join(vim_dir, next_plugin['dest'] + conf['new_dir_pfx'])
        if next_plugin['dest'] not in backup_set:
            if os.path.exists(next_dir):
                if cmd_args.clean:
                    print('{0} dir removed'.format(next_dir))
                    shutil.rmtree(next_dir, onerror=remove_readonly)
                else:
                    print('{0} already exists, remove it first!'.format(next_dir))
                    exit(2)
            os.makedirs(next_dir)
            backup_set.add(next_plugin['dest'])
        for next_getter in conf['gets']:
            if next_getter['type'] == next_plugin['get_type']:
                if not (get_plugin(next_plugin, next_getter, next_dir) or
                        'skip_on_error' in next_plugin):
                    exit(1)

                break
        else:
            print('Unknown plugin get type: {0}'.format(next_plugin['get_type']))
            exit(3)

    copy_local_plugins('local', os.path.join(vim_dir, 'bundle' + conf['new_dir_pfx']))

    remove_backup(vim_dir, conf, backup_set)


def copy_local_plugins(source_dir, target_dir):
    """ copied local plugins """
    if os.path.exists(sys.argv[0]):
        local_dir = os.path.dirname(sys.argv[0])
    else:
        local_dir = '.'
    local_dir = os.path.join(local_dir, source_dir)
    if os.path.exists(local_dir):
        for name in os.listdir(local_dir):
            from_dir = os.path.join(local_dir, name)
            if os.path.isdir(from_dir):
                to_dir = os.path.join(target_dir, name)
                print('Copying local files from {0} to {1}'.format(
                    from_dir, to_dir
                ))
                shutil.copytree(from_dir, to_dir)


def main():
    """ main subroutine """
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '--clean', action='store_const',
        const=True, default=False,
        help='clean .new dirs if exist'
    )
    cmd_args = parser.parse_args()

    get_vim_plugins(cmd_args)
    exit(0)


if __name__ == "__main__":
    main()

# vim: ts=4 sw=4
