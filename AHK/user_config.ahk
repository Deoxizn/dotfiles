; === SWITCH TO DESKTOP BY NUMBER ===
LWin & 1::switchDesktopByNumber(1)
LWin & 2::switchDesktopByNumber(2)
LWin & 3::switchDesktopByNumber(3)
LWin & 4::switchDesktopByNumber(4)
LWin & 5::switchDesktopByNumber(5)
LWin & 6::switchDesktopByNumber(6)
LWin & 7::switchDesktopByNumber(7)
LWin & 8::switchDesktopByNumber(8)
LWin & 9::switchDesktopByNumber(9)

; === NAVIGATION ===
#n::switchDesktopToRight()
#p::switchDesktopToLeft()
#s::switchDesktopToRight()
#a::switchDesktopToLeft()
#Tab::switchDesktopToLastOpened()

; === CREATE/DELETE DESKTOPS ===
#c::createVirtualDesktop()
#d::deleteVirtualDesktop()

; === MOVE WINDOW TO DESKTOP ===
#q::MoveCurrentWindowToDesktop(1)
#w::MoveCurrentWindowToDesktop(2)
#e::MoveCurrentWindowToDesktop(3)
#r::MoveCurrentWindowToDesktop(4)
#t::MoveCurrentWindowToDesktop(5)
#y::MoveCurrentWindowToDesktop(6)
#u::MoveCurrentWindowToDesktop(7)
#i::MoveCurrentWindowToDesktop(8)
#o::MoveCurrentWindowToDesktop(9)

; === MOVE WINDOW LEFT/RIGHT ===
#Right::MoveCurrentWindowToRightDesktop()
#Left::MoveCurrentWindowToLeftDesktop()

; === CUSTOM APPLICATIONS ===
#b::Run, "C:\Program Files\BraveSoftware\Brave-Browser-Beta\Application\brave.exe"
#m::Run, "C:\Users\%A_UserName%\AppData\Roaming\Spotify\Spotify.exe"
#f::Run, explorer.exe