#!/usr/bin/python
"""Script for vim plugins update"""

# ruby original - http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen

from dircache   import opendir
from os         import chmod, makedirs, remove, rename, rmdir, system
from os.path    import dirname, exists, expanduser, isdir, join
from shutil     import copytree, rmtree
from stat       import S_IWRITE
from sys        import argv, platform
from urllib2    import urlopen

# from http://stackoverflow.com/questions/1889597/deleting-directory-in-python
def remove_readonly(file_name, path, _):
    """removed read-only entity"""
    if file_name is rmdir:
        chmod(path, S_IWRITE)
        rmdir(path)
    elif file_name is remove:
        chmod(path, S_IWRITE)
        remove(path)

PATHOGEN_GIT = "git://github.com/tpope/vim-pathogen.git"

HG_BUNDLES = [
    "https://bitbucket.org/xuhdev/projecttag",
]

GIT_BUNDLES = [
    "git://github.com/hallettj/jslint.vim.git",
#    "git://github.com/joestelmach/javaScriptLint.vim.git",
    "git://github.com/motemen/git-vim.git",
    "git://github.com/mbadran/headlights.git",
    "git://github.com/scrooloose/nerdtree.git",
    "git://github.com/scrooloose/nerdcommenter.git",
    "git://github.com/kevinw/pyflakes-vim.git",
    "git://github.com/msanders/snipmate.vim.git",
    "git://github.com/scrooloose/snipmate-snippets.git",
#    "git://github.com/tpope/vim-fugitive.git",
    "git://github.com/tpope/vim-ragtag.git",
    "git://github.com/tpope/vim-surround.git",
    "git://github.com/tsaleh/vim-supertab.git",
    "git://repo.or.cz/vcscommand",
    "git://github.com/scrooloose/syntastic.git",
    "git://github.com/tsaleh/vim-tcomment.git",
    "git://github.com/mattn/zencoding-vim.git",
]

SVN_BUNDLES = [
    [ "rainbow_parenthsis", "http://vim-scripts.googlecode.com/svn/trunk/1561%20Rainbow%20Parenthsis%20Bundle/" ],
]

VIM_ORG_SCRIPTS = [
    ["zenburn",         "vim", "14110",    "colors"],
    ["jquery",          "vim", "12276",    "syntax"],
    ["python",          "vim", "12804",    "syntax"],
    ["javascript",      "vim", "10728",    "syntax"],
    ["pylint",          "vim", "10365",    "compiler"],
    ["cctree",          "vim", "15005",    "plugin"],
    ["errormarker",     "vim", "14142",    "plugin"],
    ["ScrollColor",     "vim", "5966",     "plugin"],
    ["sourceexplorer",  "vim", "14003",    "plugin"],
    ["ColorSamplerPack","zip", "12179",    "archive"],
    ["trinity",         "zip", "11988",    "archive"],
    ["taglist",         "zip", "7701",     "archive"],
]

VIM_SRC_URL = 'http://www.vim.org/scripts/download_script.php?src_id={0}'

OTHER_SCRIPTS = [
#    ["http://hlabs.spb.ru/vim/svn.vim", "vim", "syntax"],
#    ["http://hlabs.spb.ru/vim/bzr.vim", "vim", "syntax"],
#    ["http://hlabs.spb.ru/vim/rcs.vim", "vim", "syntax"],
]

vim_dir = ''

if platform == 'win32':
    vim_dir = expanduser("~/vimfiles")
else:
    vim_dir = expanduser("~/.vim")

bundles_dir = join( vim_dir, "bundle" )

if not exists(bundles_dir):
    print '{0} does not exists!'.format(bundles_dir)
    exit(2)

tmp_dir = join( vim_dir, "tmp" )
local_dir = join( vim_dir, "autoload" )
local_old_dir = local_dir + '.old'
if exists( local_old_dir ):
    print '{0} already exists, remove it first!'.format( local_old_dir )
    exit(2)
if exists( local_dir ):
    rename( local_dir, local_old_dir )
print 'Unpacking pathogen from {0} to {1}'.format(PATHOGEN_GIT, tmp_dir)
system( 'git clone {0} "{1}"'.format( PATHOGEN_GIT, tmp_dir ) )
copytree( join(tmp_dir,"autoload"), local_dir )
rmtree( tmp_dir, onerror=remove_readonly )

rename( bundles_dir, bundles_dir+'.old' )

for hg_url in HG_BUNDLES:
    hg_name = hg_url.split('/')[-1]
    if hg_name.find('.') >= 0:
        hg_name = hg_name.rpartition('.')[0]
    if hg_name == None or hg_name == '':
        print '{0} parsing name error'.format( hg_url )
        exit(3)
    local_dir = join( bundles_dir, hg_name )
    print 'Unpacking {0} to {1}'.format( hg_url, local_dir )
    makedirs( local_dir )
    system( 'hg clone {0} "{1}"'.format( hg_url, local_dir ) )
    rmtree( join( local_dir, '.hg' ), onerror=remove_readonly )

for name, ext, id, type in VIM_ORG_SCRIPTS:
    local_dir = join( bundles_dir, name, type )
    print 'Downloading {0} to {1}'.format( name, local_dir )
    makedirs( local_dir )
    url = urlopen( VIM_SRC_URL.format(id) )
    local_file = open( join(local_dir, '{0}.{1}'.format(name, ext)), 'w' )
    local_file.write( url.read() )
    local_file.close()

for url, ext, type in OTHER_SCRIPTS:
    name = url.split('/')[-1].rpartition('.')[0]
    local_dir = join( bundles_dir, name, type )
    print 'Downloading {0} to {1}'.format( url, local_dir )
    makedirs( local_dir )
    url = urlopen( url )
    local_file = open( join(local_dir, '{0}.{1}'.format(name, ext)), 'w' )
    local_file.write( url.read() )
    local_file.close()

for git_url in GIT_BUNDLES:
    git_name = git_url.split('/')[-1]
    if git_name.find('.') >= 0:
        git_name = git_name.rpartition('.')[0]
    if git_name == None or git_name == '':
        print '%(0)s parsing name error' % { '0' : git_url }
        exit(3)
    local_dir = join( bundles_dir, git_name )
    print 'Unpacking {0} to {1}'.format( git_url, local_dir )
    makedirs( local_dir )
    system( 'git clone {0} "{1}"'.format( git_url, local_dir ) )
    rmtree( join( local_dir, '.git' ), onerror=remove_readonly )

for name, svn_url in SVN_BUNDLES:
    local_dir = join( bundles_dir, name )
    print 'Unpacking {0} to {1}'.format( svn_url, local_dir )
    makedirs( local_dir )
    system( 'svn checkout {0} "{1}"'.format( svn_url, local_dir ) )
    rmtree( join( local_dir, '.svn' ), onerror=remove_readonly )

local_dir = ''

print argv[0]
if ( exists(argv[0]) ):
    local_dir = dirname(argv[0])
else:
    local_dir = '.'
local_dir = join( local_dir, 'local' )
if ( exists(local_dir) ):
    local_vim_dir = bundles_dir
    dir_names = opendir( local_dir )
    for name in dir_names:
        from_dir = join(local_dir, name)
        if ( isdir( from_dir ) ):
            to_dir = join(local_vim_dir, name)
            print 'Copying local files from {0} to {1}'.format( from_dir, to_dir )
            copytree( from_dir, to_dir )


rmtree( bundles_dir+'.old', onerror=remove_readonly )

exit(0)

# vim: set ts=4 sw=4
