function assessIntegral(varargin)
  options = Options(varargin{:});

  basis = Basis(options);

  compare('Integral of the basis function', ...
    call(basis, 'deriveIntegral', options), ...
    call(basis, 'estimateIntegral', options));

  compare('Integral of the basis function squared', ...
    call(basis, 'deriveIntegral2', options), ...
    call(basis, 'estimateIntegral2', options));
end
