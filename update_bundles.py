#!/usr/bin/python
"""Script for vim plugins update"""

# ruby original:
# http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen

import dircache
import os
import shutil
import stat
import sys
import urllib
import zipfile

import config


# from http://stackoverflow.com/questions/1889597/deleting-directory-in-python
def remove_readonly(file_name, path, _):
    """removed read-only entity"""
    if file_name is os.rmdir:
        os.chmod(path, stat.S_IWRITE)
        os.rmdir(path)
    elif file_name is os.remove:
        os.chmod(path, stat.S_IWRITE)
        os.remove(path)


def backup_dir(dir_name, backup_dir_name):
    """ backup dir """
    if os.path.exists(backup_dir_name):
        print '{0} already exists, remove it first!'.format(backup_dir_name)
        exit(2)
    if os.path.exists(dir_name):
        os.rename(dir_name, backup_dir_name)


def get_url_plugin(plugin, getter, to_dir):
    """ load 'url' plugin """
    if 'no_sub_dirs' in plugin:
        local_dir = to_dir
    else:
        to_dir = os.path.join(to_dir, plugin.name)
        local_dir = os.path.join(to_dir, plugin.type)
        os.makedirs(local_dir)
    local_file_name = os.path.join(
        local_dir,
        '{0}.{1}'.format(plugin.name, plugin.ext)
    )
    print 'Downloading {0} to {1}'.format(plugin.name, local_dir)
    urllib.urlretrieve(getter.url.format(plugin.url), local_file_name)

    if 'extract' in plugin:
        if not zipfile.is_zipfile(local_file_name):
            print '{0} is not valid zip file!'.format(local_file_name)
        else:
            local_dir = to_dir
            if plugin.extract != '':
                local_dir = os.path.join(local_dir, plugin.extract)
            print 'Extracting {0} to {1}'.format(local_file_name, local_dir)
            zip_file = zipfile.ZipFile(local_file_name, 'r')
            zip_file.extractall(local_dir)


def get_run_plugin(plugin, getter, to_dir):
    """ load 'run' plugin """
    next_name = plugin.url.split('/')[-1]
    if next_name.find('.') >= 0:
        next_name = next_name.rpartition('.')[0]
    if next_name == None or next_name == '':
        print '{0} parsing name error'.format(plugin.url)
        exit(4)
    if 'no_sub_dirs' not in plugin:
        to_dir = os.path.join(to_dir, next_name)
        if 'type' in plugin:
            to_dir = os.path.join(to_dir, plugin.type)
        os.makedirs(to_dir)
    print 'Unpacking {0} to {1}'.format(plugin.url, to_dir)
    os.system(getter.run.format(plugin.url, to_dir))
    if 'remove_dir' in getter:
        shutil.rmtree(
            os.path.join(to_dir, getter.remove_dir),
            onerror=remove_readonly
        )
    if 'no_sub_dirs' in plugin:
        dest_dir = os.path.join(to_dir, plugin.dest)
        if os.path.exists(dest_dir):
            for file_name in os.listdir(dest_dir):
                shutil.copy(os.path.join(dest_dir, file_name), to_dir)
            shutil.rmtree(dest_dir)


def get_plugin(plugin, getter, to_dir):
    """ load plugin to to_dir via getter """
    if 'url' in getter:
        get_url_plugin(plugin, getter, to_dir)
    elif 'run' in getter:
        get_run_plugin(plugin, getter, to_dir)
    else:
        print 'Unknown getter type: {0}'.format(getter.type)


def get_vim_plugins():
    """load all vim plugins"""
    vim_dir = ''

    if sys.platform == 'win32':
        vim_dir = os.path.expanduser("~/vimfiles")
    else:
        vim_dir = os.path.expanduser("~/.vim")

    cfg_file = file('plugins.cfg')
    conf = config.Config(cfg_file)

    backup_set = set()

    for next_plugin in conf.plugins:
        next_dir = os.path.join(vim_dir, next_plugin.dest + conf.new_dir_pfx)
        if next_plugin.dest not in backup_set:
            if os.path.exists(next_dir):
                print '{0} already exists, remove it first!'.format(next_dir)
                exit(2)
            os.makedirs(next_dir)
            backup_set.add(next_plugin.dest)
        for next_getter in conf.gets:
            if next_getter.type == next_plugin.get_type:
                get_plugin(next_plugin, next_getter, next_dir)
                break
        else:
            print 'Unknown plugin get type: {0}'.format(next_plugin.get_type)
            exit(3)

    copy_local_plugins(os.path.join(vim_dir, 'bundle' + conf.new_dir_pfx))

    while len(backup_set) > 0:
        next_dir = os.path.join(vim_dir, backup_set.pop())
        next_old_dir = next_dir + conf.old_dir_pfx
        if os.path.exists(next_old_dir):
            shutil.rmtree(next_old_dir, onerror=remove_readonly)
        if os.path.exists(next_dir):
            os.rename(next_dir, next_old_dir)
        next_new_dir = next_dir + conf.new_dir_pfx
        if os.path.exists(next_new_dir):
            os.rename(next_new_dir, next_dir)


def copy_local_plugins(bundles_dir):
    """ copied local plugins """
    if (os.path.exists(sys.argv[0])):
        local_dir = os.path.dirname(sys.argv[0])
    else:
        local_dir = '.'
    local_dir = os.path.join(local_dir, 'local')
    if (os.path.exists(local_dir)):
        local_vim_dir = bundles_dir
        dir_names = dircache.opendir(local_dir)
        for name in dir_names:
            from_dir = os.path.join(local_dir, name)
            if (os.path.isdir(from_dir)):
                to_dir = os.path.join(local_vim_dir, name)
                print 'Copying local files from {0} to {1}'.format(
                    from_dir, to_dir
                )
                shutil.copytree(from_dir, to_dir)


if __name__ == "__main__":
    get_vim_plugins()
    exit(0)

# vim: ts=4 sw=4
