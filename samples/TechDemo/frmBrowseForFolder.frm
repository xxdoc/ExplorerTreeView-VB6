VERSION 5.00
Object = "{CAB249C7-BAC9-4C51-9526-12F29E40C4CE}#2.5#0"; "ExTvw.ocx"
Begin VB.Form frmBrowseForFolder 
   AutoRedraw      =   -1  'True
   BorderStyle     =   3  'Fester Dialog
   Caption         =   "Nach einem Ordner durchsuchen"
   ClientHeight    =   4350
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4800
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   290
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   320
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'Bildschirmmitte
   Begin ExTvw.ExplorerTreeView ExTvw 
      Height          =   2160
      Left            =   285
      TabIndex        =   0
      Top             =   900
      Width           =   4230
      _ExtentX        =   7461
      _ExtentY        =   3810
      DragExpandTime  =   1000
      DragScrollTime  =   200
      FileAttributes  =   63
      FolderAttributes=   63
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      HotTracking     =   -1  'True
      ItemHeight      =   17
      ReplaceHandCursor=   -1  'True
      ShowFocusRect   =   0   'False
      ShownOverlays   =   2
      SingleExpand    =   2
      TreeViewStyle   =   1
   End
   Begin VB.CommandButton cmdNewFolder 
      Caption         =   "Neuen &Ordner erstellen"
      Height          =   345
      Left            =   150
      TabIndex        =   5
      Top             =   3825
      Width           =   1890
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Abbrechen"
      Height          =   345
      Left            =   3390
      TabIndex        =   4
      Top             =   3825
      Width           =   1140
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "Ok"
      Default         =   -1  'True
      Height          =   345
      Left            =   2145
      TabIndex        =   3
      Top             =   3825
      Width           =   1140
   End
   Begin VB.TextBox txtFolder 
      Height          =   285
      Left            =   1035
      TabIndex        =   2
      Top             =   3285
      Width           =   3480
   End
   Begin VB.Label lblDescr 
      AutoSize        =   -1  'True
      Caption         =   "Ordner:"
      Height          =   195
      Left            =   240
      TabIndex        =   1
      Top             =   3375
      Width           =   570
   End
   Begin VB.Label lblCaption 
      Height          =   540
      Left            =   240
      TabIndex        =   6
      Top             =   180
      Width           =   4320
   End
End
Attribute VB_Name = "frmBrowseForFolder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

  Private Type OSVERSIONINFOEX
    dwOSVersionInfoSize As Long
    dwMajorVersion As Long
    dwMinorVersion As Long
    dwBuildNumber As Long
    dwPlatformId As Long
    szCSDVersion As String * 128
    ' ab Windows NT4 SP6
    wServicePackMajor As Integer
    wServicePackMinor As Integer
    wSuiteMask As Integer
    wProductType As Byte
    wReserved As Byte
  End Type

  ' Property-Variablen

  Private propSelected As String

  Private Declare Function FreeLibrary Lib "kernel32.dll" (ByVal hLibModule As Long) As Long
  Private Declare Function GetVersionEx Lib "kernel32.dll" Alias "GetVersionExA" (Data As Any) As Long
  Private Declare Function LoadLibrary Lib "kernel32.dll" Alias "LoadLibraryA" (ByVal LibFileName As String) As Long
  Private Declare Function SetWindowTheme Lib "uxtheme.dll" (ByVal hWnd As Long, ByVal pSubAppName As Long, ByVal pSubIDList As Long) As Long


' Events

Private Sub cmdCancel_Click()
  propSelected = ""
  Me.Hide
End Sub

Private Sub cmdNewFolder_Click()
  ExTvw.ItemCreateNewFolder ExTvw.SelectedItem
End Sub

Private Sub cmdOk_Click()
  Me.Hide
End Sub

Private Sub ExTvw_ItemLoadedSubItems(ByVal hItem As Long)
  ExTvw.MousePointer = MousePointerConstants.vbDefault
  DoEvents
End Sub

Private Sub ExTvw_ItemLoadingSubItems(ByVal hItem As Long)
  ExTvw.MousePointer = MousePointerConstants.vbHourglass
  DoEvents
End Sub

Private Sub ExTVW_SelChanged(ByVal hOldItem As Long, ByVal hNewItem As Long, ByVal CausedBy As CausedByConstants)
  propSelected = ExTvw.ItemHandleToTreePath(hNewItem)
  txtFolder = ExTvw.ItemHandleToDisplayName(hNewItem)
  cmdNewFolder.Enabled = ExTvw.ItemSupportsNewFolder(hNewItem)
End Sub

Private Sub Form_Load()
  Const Size_OSVERSIONINFO = 148
  Const VER_PLATFORM_WIN32_NT = 2
  Dim hMod As Long
  Dim OSVerData As OSVERSIONINFOEX

  hMod = LoadLibrary("uxtheme.dll")
  If hMod Then
    SetWindowTheme ExTvw.hWnd, StrPtr("explorer"), 0
    FreeLibrary hMod
  End If

  With OSVerData
    .dwOSVersionInfoSize = Size_OSVERSIONINFO
    GetVersionEx OSVerData

    If .dwPlatformId = VER_PLATFORM_WIN32_NT Then
      ' use HotTracking on XP, 2003 and Vista only
      ExTvw.HotTracking = ((.dwMajorVersion = 5) And (.dwMinorVersion >= 1)) Or (.dwMajorVersion >= 6)
      ' use ReplaceHandCursor on XP and 2003 only
      ExTvw.ReplaceHandCursor = ((.dwMajorVersion = 5) And (.dwMinorVersion >= 1))
      ' use lines on XP, 2003 and Vista only
      ExTvw.TreeViewStyle = TreeViewStyleConstants.tvsButtons Or IIf(((.dwMajorVersion = 5) And (.dwMinorVersion >= 1)) Or (.dwMajorVersion >= 6), 0, TreeViewStyleConstants.tvsLines)
    Else
      ExTvw.HotTracking = False
      ExTvw.ReplaceHandCursor = False
      ExTvw.TreeViewStyle = TreeViewStyleConstants.tvsButtons Or TreeViewStyleConstants.tvsLines
    End If
  End With

  ExTvw.hWndShellUIParentWindow = Me.hWnd

  cmdNewFolder.Enabled = ExTvw.ItemSupportsNewFolder(ExTvw.SelectedItem)
End Sub

Private Sub txtFolder_GotFocus()
  txtFolder.SelStart = 0
  txtFolder.SelLength = Len(txtFolder)
End Sub


' �ffentliche Props

Public Property Get Selected() As String
  Selected = propSelected
End Property


' �ffentliche Methoden

Public Sub showIt(ByVal ForPathProp As Boolean, ByVal RootPath As String, ByVal Path As String, ByVal IncludedItems As Long, ByVal FileAttributes As Long, ByVal FolderAttributes As Long, ByVal FileFilters As String, ByVal FolderFilters As String, ByVal ExpandArchives As Integer)
  With ExTvw
    .IncludedItems = IncludedItems
    .FileAttributes = FileAttributes
    .FolderAttributes = FolderAttributes
    .FileFilters = FileFilters
    .UseFileFilters = (FileFilters <> "")
    .FolderFilters = FolderFilters
    .UseFolderFilters = (FolderFilters <> "")
    .RootPath = RootPath
    .Path = Path
    If ForPathProp Then
      lblCaption = "W�hlen Sie den Item, der gerade markiert sein soll."
      .ExpandArchives = ExpandArchives
    Else
      lblCaption = "W�hlen Sie den Item, der als Startverzeichnis dienen soll."
      .ExpandArchives = 0
      .IncludedItems = .IncludedItems And Not iiFSFiles
      .IncludedItems = .IncludedItems And Not iiNonFSFiles
    End If
  End With

  Me.Show FormShowConstants.vbModal
End Sub
