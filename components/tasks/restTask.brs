sub init()
  m.messagePort = CreateObject("roMessagePort")
  m.top.observeField("request", m.messagePort)
  m.top.functionname = "makeRequest"
end sub

sub makeRequest()
  urlTransfer = createObject("roUrlTransfer")
  urlTransfer.RetainBodyOnError(true)
  urlTransfer.setPort(m.messagePort)
  urlTransfer.setCertificatesFile("common:/certs/ca-bundle.crt")
  urlTransfer.InitClientCertificates()

  while true
    msg = wait(0, m.messagePort)
    if "roUrlEvent" = type(msg)
      if (msg.getresponsecode() > 0 and  msg.getresponsecode() < 400)
        if (msg.getresponsecode() > 300)
          ? "Redirected!"
        end if
        m.top.response = msg.getstring()
        urlTransfer.asynccancel()
      else
        ? "request error: "; msg.getfailurereason();" "; msg.getresponsecode();
        m.top.response = ""
        urlTransfer.asynccancel()
      end if
    else if "request" = msg.getField()
      url = msg.getData().url
      urlTransfer.setUrl(url)
      urlTransfer.AsyncGetToString()
    end if
  end while
end sub