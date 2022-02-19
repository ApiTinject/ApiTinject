object Servico_Whats: TServico_Whats
  OldCreateOrder = False
  Height = 150
  Width = 215
  object Inject: TInject
    InjectJS.AutoUpdateTimeOut = 10
    Config.AutoDelay = 1000
    AjustNumber.LengthPhone = 8
    AjustNumber.DDIDefault = 55
    FormQrCodeType = Ft_Http
    OnGetStatus = InjectGetStatus
    Left = 88
    Top = 16
  end
end
