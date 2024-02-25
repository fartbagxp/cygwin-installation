# Installation

The following instructions are to install [Cygwin](https://www.cygwin.com/) on a Windows machine with a user with no administrative permissions.

1. Navigate to [Cygwin Install Page](https://cygwin.com/install.html) and download the 64 bit version (preferred) of the executable (setup-x86_64.exe).
1. Open up a Windows PowerShell terminal.
1. Navigate to the executable directory (by default, the Downloads folder).
1. Type in `setup-x86_64.exe --no-admin` and the setup user interface should pop. This command forces the installation to be in user mode, rather than administrative mode.

1. During the setup sequence, the following will be prompted:
   **Setup Screen**

   - Click "Next".

   **Choose a Download Source**

   - Select 'Install from Internet', Click "Next".

   **Select Root Install Directory**

   - By default, it'll be installed to **c:\cygwin** and it'll be for all users on the machine.
   - Click "Next".

   **Select Local Package Directory**

   - Click "Next".

   **Select Your Internet Connection**

   - Click "Next". By default, it will simply use your system proxy settings.

   **Choose a Download Site**

   This refers to where cygwin packages of open source software will be downloaded from. It is best to choose a closest location to you, and a location that you trust downloading binaries from.

   I generally choose the mirror source of Virginia Tech (VT) or Rochester Institute of Technlogy (RIT) as I'm on the East Coast.

   - Once selected, click "Next".

   **Select Packages**

   - Click "Next".

   **Review and confirm changes**

   - Click "Next".

   **Progress**

   - Wait for install to complete

   **Create Icons**

   - Feel free to create an icon on Desktop.
   - Click 'Finish'

1. You should now be able to open up your Cygwin terminal.
