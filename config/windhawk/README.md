# Windhawk

Windows 11 taskbar and Start menu settings: dark translucent backgrounds,
rounded corners, and a compact taskbar.

| Settings file | Windhawk mod |
| --- | --- |
| [`taskbar-styler.yaml`](taskbar-styler.yaml) | [Windows 11 Taskbar Styler](https://windhawk.net/mods/windows-11-taskbar-styler) |
| [`taskbar-height.yaml`](taskbar-height.yaml) | [Taskbar height and icon size](https://windhawk.net/mods/taskbar-icon-size) |
| [`start-menu-styler.yaml`](start-menu-styler.yaml) | [Windows 11 Start Menu Styler](https://windhawk.net/mods/windows-11-start-menu-styler) |

## Apply

1. Install [Windhawk](https://windhawk.net/) and the matching mods above.
2. Open a mod's **Settings** tab and select **Textual mode**. Save a copy of
   your current settings before replacing them.
3. Paste the complete contents of the corresponding YAML file and select
   **Save settings**. Repeat for the other mods you want to use.

Each file belongs to one mod; do not combine them into a single import. The
taskbar sizing preset uses a height of 46 and icon size of 22. Colors, blur,
and spacing are defined directly in the styling files.

These target Windows 11. Windows updates and mod versions can change the UI
elements being styled. If a style stops applying, check the upstream
[taskbar guide](https://github.com/ramensoftware/windows-11-taskbar-styling-guide)
or [Start menu guide](https://github.com/ramensoftware/windows-11-start-menu-styling-guide).
To undo a customization, restore the saved settings or disable its mod.
