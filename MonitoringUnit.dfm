object MonitoringForm: TMonitoringForm
  Left = 0
  Top = 0
  Caption = 'MonitoringForm'
  ClientHeight = 291
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 253
    Width = 417
    Height = 38
    Align = alBottom
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 1
    ExplicitTop = 244
    ExplicitWidth = 415
    DesignSize = (
      417
      38)
    object btnSaveLog: TButton
      Left = 338
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Save log'
      TabOrder = 0
      OnClick = btnSaveLogClick
      ExplicitLeft = 336
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 417
    Height = 33
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 418
    object cbAutoScrolling: TCheckBox
      Left = 120
      Top = 8
      Width = 97
      Height = 17
      Caption = 'AutoScrolling'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbAutoScrollingClick
    end
    object chOnOff: TCheckBox
      Left = 17
      Top = 8
      Width = 97
      Height = 17
      Caption = 'On/Off'
      TabOrder = 1
      OnClick = chOnOffClick
    end
  end
  object lbLogs: TListBox
    Left = 0
    Top = 33
    Width = 417
    Height = 220
    Align = alClient
    ItemHeight = 13
    TabOrder = 2
    ExplicitLeft = 224
    ExplicitTop = 152
    ExplicitWidth = 121
    ExplicitHeight = 97
  end
  object SaveDialog1: TSaveDialog
    Left = 248
    Top = 8
  end
end
