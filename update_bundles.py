#!/usr/bin/python

# ruby original from http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen

from os         import chdir, chmod, makedirs, remove, rename, rmdir, system;
from os.path    import *;
from re         import match;
from shutil     import copytree,rmtree;
from stat       import S_IWRITE;
from sys        import exit, platform;
from urllib2    import urlopen;

# from http://stackoverflow.com/questions/1889597/deleting-directory-in-python
def remove_readonly(fn, path, excinfo):
    if fn is rmdir:
        chmod(path, S_IWRITE)
        rmdir(path)
    elif fn is remove:
        chmod(path, S_IWRITE)
        remove(path)

pathogen_git = "git://github.com/tpope/vim-pathogen.git";

git_bundles = [ 
    "git://github.com/motemen/git-vim.git",
#    "git://github.com/scrooloose/nerdtree.git",
    "git://github.com/msanders/snipmate.vim.git",
    "git://github.com/scrooloose/snipmate-snippets.git",
#    "git://github.com/tpope/vim-fugitive.git",
    "git://github.com/tpope/vim-ragtag.git",
    "git://github.com/tpope/vim-surround.git",
    "git://github.com/tsaleh/vim-supertab.git",
    "git://github.com/tsaleh/vim-tcomment.git",
]

svn_bundles = [
    [ "rainbow_parenthsis", "http://vim-scripts.googlecode.com/svn/trunk/1561%20Rainbow%20Parenthsis%20Bundle/" ],
]

vim_org_scripts = [
    ["jquery",          "vim", "12276",    "syntax"],
    ["python",          "vim", "12804",    "syntax"],
    ["javascript",      "vim", "10728",    "syntax"],
    ["ScrollColor",     "vim", "5966",     "plugin"],
    ["ColorSamplerPack","zip", "12179",    "archive"],
]

other_scripts = [
    ["http://hlabs.spb.ru/vim/svn.vim", "vim", "syntax"],
    ["http://hlabs.spb.ru/vim/bzr.vim", "vim", "syntax"],
    ["http://hlabs.spb.ru/vim/rcs.vim", "vim", "syntax"],
]

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
if exists( local_dir ):
    rename( local_dir, local_dir+'.old' )
print 'Unpacking pathogen from {0} to {1}'.format(pathogen_git,tmp_dir)
system( 'git clone {0} "{1}"'.format( pathogen_git, tmp_dir ) )
copytree( join(tmp_dir,"autoload"), local_dir )
rmtree( tmp_dir, onerror=remove_readonly )

rename( bundles_dir, bundles_dir+'.old' );

for name, ext, id, type in vim_org_scripts:
    local_dir = join( bundles_dir, name, type )
    print 'Downloading {0} to {1}'.format( name, local_dir )
    makedirs( local_dir )
    url = urlopen( 'http://www.vim.org/scripts/download_script.php?src_id={0}'.format(id) )
    local_file = open( join(local_dir,'{0}.{1}'.format(name,ext)), 'w' )
    local_file.write( url.read() )
    local_file.close()

for url, ext, type in other_scripts:
    name = url.split('/')[-1].rpartition('.')[0]
    local_dir = join( bundles_dir, name, type )
    print 'Downloading {0} to {1}'.format( url, local_dir )
    makedirs( local_dir )
    url = urlopen( url )
    local_file = open( join(local_dir,'{0}.{1}'.format(name,ext)), 'w' )
    local_file.write( url.read() )
    local_file.close()

for git_url in git_bundles:
    git_name = git_url.split('/')[-1].rpartition('.')[0]
    if git_name == None:
        print '{0} parsing name error'.format( git_url );
        exit(3)
    local_dir = join( bundles_dir, git_name )
    print 'Unpacking {0} to {1}'.format( git_url, local_dir )
    makedirs( local_dir )
    system( 'git clone {0} "{1}"'.format( git_url, local_dir ) )
    rmtree( join( local_dir, '.git' ), onerror=remove_readonly )

for name, svn_url in svn_bundles:
    local_dir = join( bundles_dir, name )
    print 'Unpacking {0} to {1}'.format( svn_url, local_dir )
    makedirs( local_dir )
    system( 'svn checkout {0} "{1}"'.format( svn_url, local_dir ) )
    rmtree( join( local_dir, '.svn' ), onerror=remove_readonly )

rmtree( bundles_dir+'.old', onerror=remove_readonly )

exit(0)

