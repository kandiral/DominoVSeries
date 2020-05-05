object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'OmronFQ_CR1 Test'
  ClientHeight = 410
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 233
    Height = 391
    Align = alLeft
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object btnConnection: TButton
      Left = 16
      Top = 9
      Width = 121
      Height = 25
      Caption = 'Connection'
      TabOrder = 0
      OnClick = btnConnectionClick
    end
    object btnStartMeasurements: TButton
      Left = 16
      Top = 138
      Width = 121
      Height = 25
      Caption = 'StartMeasurements'
      TabOrder = 1
      OnClick = btnStartMeasurementsClick
    end
    object statStartMeasurements: TEdit
      Left = 143
      Top = 142
      Width = 75
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object btnStopMeasurements: TButton
      Left = 16
      Top = 169
      Width = 121
      Height = 25
      Caption = 'StopMeasurements'
      TabOrder = 3
      OnClick = btnStopMeasurementsClick
    end
    object statStopMeasurements: TEdit
      Left = 143
      Top = 171
      Width = 75
      Height = 21
      ReadOnly = True
      TabOrder = 4
    end
    object btnExecuteMeasurement: TButton
      Left = 16
      Top = 224
      Width = 121
      Height = 25
      Caption = 'ExecuteMeasurement'
      TabOrder = 5
      OnClick = btnExecuteMeasurementClick
    end
    object statExecuteMeasurement: TEdit
      Left = 143
      Top = 228
      Width = 75
      Height = 21
      ReadOnly = True
      TabOrder = 6
    end
    object ExecuteMeasurementValue: TEdit
      Left = 16
      Top = 255
      Width = 202
      Height = 21
      ReadOnly = True
      TabOrder = 7
    end
    object btnMonitoring: TButton
      Left = 16
      Top = 40
      Width = 121
      Height = 25
      Caption = 'Monitoring'
      TabOrder = 8
      OnClick = btnMonitoringClick
    end
    object btnReset: TButton
      Left = 16
      Top = 87
      Width = 121
      Height = 25
      Caption = 'Reset'
      TabOrder = 9
      OnClick = btnResetClick
    end
    object btnClearMeasurement: TButton
      Left = 16
      Top = 304
      Width = 121
      Height = 25
      Caption = 'ClearMeasurements'
      TabOrder = 10
      OnClick = btnClearMeasurementClick
    end
    object statClearMeasurement: TEdit
      Left = 143
      Top = 306
      Width = 75
      Height = 21
      ReadOnly = True
      TabOrder = 11
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 391
    Width = 650
    Height = 19
    Panels = <
      item
        Width = 120
      end>
  end
  object Panel2: TPanel
    Left = 233
    Top = 0
    Width = 417
    Height = 391
    Align = alClient
    BevelOuter = bvLowered
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 2
    object Panel3: TPanel
      Left = 1
      Top = 352
      Width = 415
      Height = 38
      Align = alBottom
      Caption = 'Panel3'
      ShowCaption = False
      TabOrder = 0
      DesignSize = (
        415
        38)
      object cbAutoScrolling: TCheckBox
        Left = 16
        Top = 8
        Width = 97
        Height = 17
        Caption = 'AutoScrolling'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbAutoScrollingClick
      end
      object btnSaveLog: TButton
        Left = 336
        Top = 6
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Save log'
        TabOrder = 1
        OnClick = btnSaveLogClick
      end
    end
    object ListBox1: TListBox
      Left = 1
      Top = 1
      Width = 415
      Height = 351
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 168
    Top = 8
  end
end
