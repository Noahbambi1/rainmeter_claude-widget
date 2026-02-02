# Toggle Desktop Icons without restarting Explorer
# Uses SendMessage to toggle visibility of SHELLDLL_DefView

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class DesktopIcons {
    [DllImport("user32.dll", SetLastError = true)]
    static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll", SetLastError = true)]
    static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);

    [DllImport("user32.dll", SetLastError = true)]
    static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

    const uint WM_COMMAND = 0x0111;

    public static void Toggle() {
        IntPtr progman = FindWindow("Progman", "Program Manager");
        IntPtr defView = FindWindowEx(progman, IntPtr.Zero, "SHELLDLL_DefView", null);

        // If not found under Progman, search under WorkerW windows
        if (defView == IntPtr.Zero) {
            IntPtr workerW = IntPtr.Zero;
            do {
                workerW = FindWindowEx(IntPtr.Zero, workerW, "WorkerW", null);
                defView = FindWindowEx(workerW, IntPtr.Zero, "SHELLDLL_DefView", null);
            } while (defView == IntPtr.Zero && workerW != IntPtr.Zero);
        }

        if (defView != IntPtr.Zero) {
            // 0x7402 is the command ID for toggling desktop icons
            SendMessage(defView, WM_COMMAND, (IntPtr)0x7402, IntPtr.Zero);
        }
    }
}
"@

[DesktopIcons]::Toggle()
