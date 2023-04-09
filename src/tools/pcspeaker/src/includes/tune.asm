%define cx(d) ((d * 1000) >> 16)
%define dx(d) ((d * 1000)  & 0xFFFF)

tune  dw  n60, cx(200), dx(200)
      dw nBRK, cx(200), dx(200)

      dw  n72, cx(350), dx(350)
      dw nBRK, cx(200), dx(200)

      dw  n71, cx(300), dx(300)
      dw nBRK, cx(200), dx(200)

      dw  n72, cx(400), dx(400)
      dw nBRK, cx(350), dx(350)

      dw  n67, cx(300), dx(300)
      dw nBRK, cx(200), dx(200)

      dw  n64, cx(400), dx(400)
      dw nBRK, cx(200), dx(200)

      dw  n69, cx(350), dx(250)
      dw nBRK, cx(200), dx(200)

      dw  n67, cx(400), dx(400)
      dw nEND, 0, 0