VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "IHook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' �ffentliche Methoden

Public Function CallWndProcAfter(ByVal HookCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
  '
End Function

Public Function CallWndProcBefore(ByVal HookCode As Long, ByVal wParam As Long, ByVal lParam As Long, ByRef eatIt As Boolean) As Long
  '
End Function

Public Function CBTProcAfter(ByVal HookCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
  '
End Function

Public Function CBTProcBefore(ByVal HookCode As Long, ByVal wParam As Long, ByVal lParam As Long, ByRef eatIt As Boolean) As Long
  '
End Function

Public Function MouseProcAfter(ByVal HookCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
  '
End Function

Public Function MouseProcBefore(ByVal HookCode As Long, ByVal wParam As Long, ByVal lParam As Long, ByRef eatIt As Boolean) As Long
  '
End Function