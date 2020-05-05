object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 681
  ClientWidth = 690
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 662
    Width = 690
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 690
    Height = 377
    Align = alTop
    Caption = 'Status'
    TabOrder = 1
    object Label1: TLabel
      Left = 103
      Top = 88
      Width = 87
      Height = 13
      Caption = 'Status Description'
    end
    object Label2: TLabel
      Left = 103
      Top = 183
      Width = 80
      Height = 13
      Caption = 'Error Description'
    end
    object Label3: TLabel
      Left = 103
      Top = 278
      Width = 96
      Height = 13
      Caption = 'Warning Description'
    end
    object LabeledEdit1: TLabeledEdit
      Left = 80
      Top = 24
      Width = 241
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = 'Print Name'
      LabelPosition = lpLeft
      LabelSpacing = 6
      ReadOnly = True
      TabOrder = 0
    end
    object LabeledEdit2: TLabeledEdit
      Left = 80
      Top = 51
      Width = 97
      Height = 21
      EditLabel.Width = 54
      EditLabel.Height = 13
      EditLabel.Caption = 'Print Count'
      LabelPosition = lpLeft
      LabelSpacing = 6
      ReadOnly = True
      TabOrder = 1
    end
    object LabeledEdit3: TLabeledEdit
      Left = 16
      Top = 107
      Width = 81
      Height = 21
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = 'Status Code'
      LabelSpacing = 5
      ReadOnly = True
      TabOrder = 2
    end
    object Memo1: TMemo
      Left = 103
      Top = 107
      Width = 402
      Height = 70
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 3
    end
    object Memo2: TMemo
      Left = 103
      Top = 202
      Width = 402
      Height = 70
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 4
    end
    object LabeledEdit4: TLabeledEdit
      Left = 16
      Top = 202
      Width = 81
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = 'Error Code'
      LabelSpacing = 5
      ReadOnly = True
      TabOrder = 5
    end
    object Memo3: TMemo
      Left = 103
      Top = 297
      Width = 402
      Height = 70
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 6
    end
    object LabeledEdit5: TLabeledEdit
      Left = 16
      Top = 297
      Width = 81
      Height = 21
      EditLabel.Width = 68
      EditLabel.Height = 13
      EditLabel.Caption = 'Warning Code'
      LabelSpacing = 5
      ReadOnly = True
      TabOrder = 7
    end
    object Button2: TButton
      Left = 327
      Top = 22
      Width = 121
      Height = 25
      Caption = #1057#1073#1088#1086#1089' '#1086#1096#1080#1073#1082#1080
      TabOrder = 8
      OnClick = Button2Click
    end
    object Button7: TButton
      Left = 528
      Top = 211
      Width = 75
      Height = 25
      Caption = 'SerialVars'
      TabOrder = 9
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 528
      Top = 83
      Width = 75
      Height = 25
      Caption = 'PrintDesign'
      TabOrder = 10
      OnClick = Button8Click
    end
    object Button5: TButton
      Left = 528
      Top = 247
      Width = 75
      Height = 25
      Caption = 'CancelPrint'
      TabOrder = 11
      OnClick = Button5Click
    end
    object LabeledEdit8: TLabeledEdit
      Left = 528
      Top = 56
      Width = 145
      Height = 21
      EditLabel.Width = 46
      EditLabel.Height = 13
      EditLabel.Caption = 'File Name'
      LabelSpacing = 5
      ReadOnly = True
      TabOrder = 12
      Text = '1.design'
    end
    object LabeledEdit9: TLabeledEdit
      Left = 528
      Top = 144
      Width = 145
      Height = 21
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = 'VTEXT'
      LabelSpacing = 5
      ReadOnly = True
      TabOrder = 13
      Text = '1'
    end
    object LabeledEdit10: TLabeledEdit
      Left = 528
      Top = 184
      Width = 145
      Height = 21
      EditLabel.Width = 36
      EditLabel.Height = 13
      EditLabel.Caption = 'VTEXT2'
      LabelSpacing = 5
      ReadOnly = True
      TabOrder = 14
      Text = #1056#1091#1089#1089#1082#1080#1081
    end
    object LabeledEdit11: TLabeledEdit
      Left = 528
      Top = 297
      Width = 145
      Height = 21
      EditLabel.Width = 43
      EditLabel.Height = 13
      EditLabel.Caption = 'VarName'
      LabelSpacing = 5
      ReadOnly = True
      TabOrder = 15
      Text = 'VTEXT2'
    end
    object Button6: TButton
      Left = 528
      Top = 324
      Width = 75
      Height = 25
      Caption = 'PollSerialVar'
      TabOrder = 16
      OnClick = Button6Click
    end
    object Edit1: TEdit
      Left = 531
      Top = 355
      Width = 142
      Height = 21
      TabOrder = 17
      Text = 'Edit1'
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 377
    Width = 353
    Height = 285
    Align = alLeft
    Caption = 'Request'
    TabOrder = 2
    object Panel1: TPanel
      Left = 2
      Top = 15
      Width = 349
      Height = 41
      Align = alTop
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 0
      object LabeledEdit6: TLabeledEdit
        Left = 62
        Top = 12
        Width = 156
        Height = 21
        EditLabel.Width = 47
        EditLabel.Height = 13
        EditLabel.Caption = 'Command'
        LabelPosition = lpLeft
        LabelSpacing = 5
        TabOrder = 0
      end
      object Button1: TButton
        Left = 224
        Top = 10
        Width = 75
        Height = 25
        Caption = 'Send'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 242
      Width = 349
      Height = 41
      Align = alBottom
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 1
      DesignSize = (
        349
        41)
      object Button3: TButton
        Left = 264
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Clear'
        TabOrder = 0
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 183
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Add'
        TabOrder = 1
        OnClick = Button4Click
      end
    end
    object ListBox1: TListBox
      Left = 2
      Top = 56
      Width = 349
      Height = 186
      Align = alClient
      ItemHeight = 13
      TabOrder = 2
      OnDblClick = ListBox1DblClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 353
    Top = 377
    Width = 337
    Height = 285
    Align = alClient
    Caption = 'Answer'
    TabOrder = 3
    object Panel3: TPanel
      Left = 2
      Top = 15
      Width = 333
      Height = 41
      Align = alTop
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 0
      object LabeledEdit7: TLabeledEdit
        Left = 62
        Top = 12
        Width = 211
        Height = 21
        EditLabel.Width = 47
        EditLabel.Height = 13
        EditLabel.Caption = 'Command'
        LabelPosition = lpLeft
        LabelSpacing = 5
        ReadOnly = True
        TabOrder = 0
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 242
      Width = 333
      Height = 41
      Align = alBottom
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 1
      object Label4: TLabel
        Left = 14
        Top = 14
        Width = 31
        Height = 13
        Caption = 'Label4'
      end
    end
    object ListBox2: TListBox
      Left = 2
      Top = 56
      Width = 333
      Height = 186
      Align = alClient
      ItemHeight = 13
      TabOrder = 2
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 248
    Top = 48
  end
end
