gluonTailLength[L_, n_, R_] := Module[
  {pitch},
  pitch = L/Max[n, 1];
  Min[0.35 L, Max[2 R, 0.6 pitch]]
]

gluonPlotCentered[p0_, p1_, n_, R_, sign_] := Module[
  {
    L, u, normal,
    tailLength, coreLength, pFake,
    xt, yt, corePoint,
    tailRise, c1, c2,
    corePlot, tailPlot
  },
  L = EuclideanDistance[p0, p1];
  u = Normalize[p1 - p0];
  normal = {-u[[2]], u[[1]]};
  
  (* 1. 预留末端点所需空位，并构造假的末端点 *)
  tailLength = gluonTailLength[L, n, R];
  coreLength = Max[L - tailLength, L/4];
  pFake = p0 + coreLength u;
  
  (* 2. 在起点与假的末端点之间按原相位平移算法绘制 loop *)
  xt[t_] := t*coreLength - R*Cos[2 Pi n t] + R;
  yt[t_] := sign*R*Sin[2 Pi n t];
  corePoint[t_] := p0 + xt[t]*u + yt[t]*normal;
  
  corePlot = ParametricPlot[
    corePoint[t],
    {t, 0, 1},
    Axes -> False,
    PlotStyle -> {Black, Thickness[0.005]},
    PlotRange -> All,
    PlotPoints -> 200
  ];
  
  (* 3. 让真假末端点之间保留与主 loop 相近的振幅，再光滑落回真末端点 *)
  tailRise = 4 R/3;
  c1 = pFake + (tailLength/3) u + sign*tailRise normal;
  c2 = p1 - (tailLength/3) u + sign*tailRise normal;
  
  tailPlot = Graphics[{
    Black,
    Thickness[0.005],
    BezierCurve[{pFake, c1, c2, p1}]
  }];
  
  Show[
    corePlot,
    tailPlot,
    PlotRange -> All
  ]
]

(* 测试：起点{0,0}，终点{10,0}，5个 loop，半径0.6，倒 U 形 *)
gluonPlotCentered[{0, 0}, {10, 0}, 5, 0.6, 1]
