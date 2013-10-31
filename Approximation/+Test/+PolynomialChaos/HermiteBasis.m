function HermiteBasis
  setup;
  surrogate = PolynomialChaos.Hermite( ...
    'inputCount', 1, 'outputCount', 1, 'order', 5);
  plot(surrogate);
  xlim([ -3, 3 ]);
  ylim([ -15, 15 ]);
end