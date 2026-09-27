# Installation

These steps install [Cygwin](https://www.cygwin.com/) on Windows as a regular user, without administrator rights.

1. Go to the [Cygwin install page](https://cygwin.com/install.html) and download the 64-bit installer, `setup-x86_64.exe`.
1. Open up a Windows PowerShell terminal.
1. Change to the folder you downloaded it to (usually Downloads).
1. Run `.\setup-x86_64.exe --no-admin`. The setup window should pop up. `--no-admin` installs in user mode, so Windows won't ask for administrator rights.

1. Click through the setup screens:

   **Setup Screen**

   - Click "Next".

   **Choose a Download Source**

   - Select "Install from Internet", then click "Next".

   **Select Root Install Directory**

   - The default is `C:\cygwin`, installed for all users on the machine.
   - Click "Next".

   **Select Local Package Directory**

   - Click "Next".

   **Select Your Internet Connection**

   - Click "Next". The default uses your system proxy settings.

   **Choose a Download Site**

   This is the mirror Cygwin downloads packages from. Pick one close to you that you trust to serve binaries.

   I usually pick Virginia Tech (VT) or Rochester Institute of Technology (RIT).

   - Once selected, click "Next".

   **Select Packages**

   - Click "Next".

   **Review and Confirm Changes**

   - Click "Next".

   **Progress**

   - Wait for the install to finish.

   **Create Icons**

   - Add a desktop icon if you want one.
   - Click "Finish".

1. Open the Cygwin terminal from the Start menu or the desktop icon.
