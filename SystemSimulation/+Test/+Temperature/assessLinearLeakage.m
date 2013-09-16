function assessLinearLeakage(varargin)
  compare( ...
    Options(varargin{:}, 'analysis', 'DynamicSteadyState'), ...
    Options('linearizeLeakage', Options( ...
      'T', Utils.toKelvin([ 50, 100 ]), ...
      'Leff', 45e-9 + 0.05 * 45e-9 * [ -1, 1 ])));
end
