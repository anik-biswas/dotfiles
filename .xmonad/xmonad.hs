import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor
import XMonad.Hooks.SetWMName

myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    ]

myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "compton &"
    spawnOnce "urxvtd -q -o -f &"
    spawnOnce "lxpolkit &"
    setWMName "LG3D"
    setDefaultCursor xC_left_ptr

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ docks defaultConfig
        { manageHook = myManageHook <+> manageHook defaultConfig -- make sure to include myManageHook definition from above
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , terminal = "urxvtc"
        , startupHook = myStartupHook
        , XMonad.workspaces = ["web", "term", "code" ] ++ map show [4..9]
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        ]
