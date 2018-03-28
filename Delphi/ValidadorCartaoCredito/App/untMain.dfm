object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Validador de Cart'#227'o'
  ClientHeight = 261
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgBandeira: TImage
    Left = 0
    Top = 0
    Width = 334
    Height = 105
    Align = alTop
    Stretch = True
    ExplicitLeft = 104
    ExplicitTop = 24
    ExplicitWidth = 105
  end
  object edtNro: TEdit
    Left = 8
    Top = 112
    Width = 313
    Height = 21
    TabOrder = 0
    TextHint = 'N'#250'mero do Cart'#227'o'
    OnKeyPress = edtNroKeyPress
  end
  object btValidar: TButton
    Left = 160
    Top = 139
    Width = 162
    Height = 94
    Caption = 'Validar'
    TabOrder = 1
    OnClick = btValidarClick
  end
  object sbCartao: TStatusBar
    Left = 0
    Top = 242
    Width = 334
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'V'#193'LIDO / INV'#193'LIDO'
        Width = 200
      end>
  end
  object rgForma: TRadioGroup
    Left = 8
    Top = 139
    Width = 146
    Height = 94
    Caption = 'Forma de Valida'#231#227'o'
    ItemIndex = 1
    Items.Strings = (
      'Acbr'
      'App'
      'Dll')
    TabOrder = 3
  end
end
