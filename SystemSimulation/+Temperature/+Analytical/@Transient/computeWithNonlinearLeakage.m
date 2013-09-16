function [ T, output ] = computeWithNonlinearLeakage(this, Pdyn, options)
  [ processorCount, stepCount ] = size(Pdyn);
  assert(processorCount == this.processorCount);

  C = this.C;
  E = this.E;
  F = this.F;
  Tamb = this.Tamb;

  leakage = this.leakage;

  parameters = options.get('parameters', struct);
  parameters.T = NaN;

  [ parameters, dimensions, Tindex ] = leakage.assign( ...
    'assignments', parameters, 'dimensions', [ processorCount, NaN ]);
  assert(isscalar(Tindex));

  sampleCount = dimensions(2);

  T = zeros(processorCount, stepCount, sampleCount);
  P = zeros(processorCount, stepCount, sampleCount);

  parameters{Tindex} = Tamb * ones(processorCount, sampleCount);
  P_ = bsxfun(@plus, Pdyn(:, 1), leakage.compute(parameters{:}));
  X_ = F * P_;
  T_ = C * X_ + Tamb;

  T(:, 1, :) = T_;
  P(:, 1, :) = P_;

  for i = 2:stepCount
    parameters{Tindex} = T_;
    P_ = bsxfun(@plus, Pdyn(:, i), leakage.compute(parameters{:}));
    X_ = E * X_ + F * P_;
    T_ = C * X_ + Tamb;

    T(:, i, :) = T_;
    P(:, i, :) = P_;
  end

  output.P = P;
end
