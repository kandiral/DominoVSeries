object OmronFQ_CR1SetsForm: TOmronFQ_CR1SetsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'OmronFQ_CR1 '
  ClientHeight = 246
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 205
    Width = 273
    Height = 41
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 265
    DesignSize = (
      273
      41)
    object Button1: TButton
      Left = 191
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 183
    end
    object Button2: TButton
      Left = 110
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      TabOrder = 1
      OnClick = Button2Click
      ExplicitLeft = 102
    end
  end
  object leAddr: TLabeledEdit
    Left = 168
    Top = 40
    Width = 97
    Height = 21
    EditLabel.Width = 43
    EditLabel.Height = 13
    EditLabel.Caption = 'IP '#1072#1076#1088#1077#1089
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 1
  end
  object lePort: TLabeledEdit
    Left = 168
    Top = 67
    Width = 97
    Height = 21
    EditLabel.Width = 25
    EditLabel.Height = 13
    EditLabel.Caption = #1055#1086#1088#1090
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 2
  end
  object leConnectTimeout: TLabeledEdit
    Left = 168
    Top = 94
    Width = 97
    Height = 21
    EditLabel.Width = 115
    EditLabel.Height = 13
    EditLabel.Caption = #1058#1072#1081#1084#1072#1091#1090' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 3
  end
  object leReconnectTime: TLabeledEdit
    Left = 168
    Top = 121
    Width = 97
    Height = 21
    EditLabel.Width = 127
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1088#1077#1084#1103' '#1087#1077#1088#1077#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 4
  end
  object leReadTimeout: TLabeledEdit
    Left = 168
    Top = 148
    Width = 97
    Height = 21
    EditLabel.Width = 81
    EditLabel.Height = 13
    EditLabel.Caption = #1058#1072#1081#1084#1072#1091#1090' '#1095#1090#1077#1085#1080#1103
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 5
  end
  object leErrGetTime: TLabeledEdit
    Left = 168
    Top = 175
    Width = 97
    Height = 21
    EditLabel.Width = 149
    EditLabel.Height = 13
    EditLabel.Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1089#1090#1072#1090#1091#1089#1072
    LabelPosition = lpLeft
    LabelSpacing = 6
    TabOrder = 6
  end
  object leName: TLabeledEdit
    Left = 168
    Top = 13
    Width = 97
    Height = 21
    EditLabel.Width = 19
    EditLabel.Height = 13
    EditLabel.Caption = #1048#1084#1103
    LabelPosition = lpLeft
    LabelSpacing = 6
    MaxLength = 64
    TabOrder = 7
  end
end
