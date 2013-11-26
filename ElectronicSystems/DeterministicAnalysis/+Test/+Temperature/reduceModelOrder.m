function reduceModelOrder(varargin)
  close all;
  setup;

  options = Configure.systemSimulation(varargin{:});
  options = Configure.deterministicAnalysis(options);

  errorMetric = 'RMSE';

  one = Temperature(options.temperatureOptions);
  Tone = Utils.toCelsius(one.compute(options.dynamicPower));

  minimalError = 0.1;
  reductionLimit = 0.4:0.05:1;

  fprintf('%15s%15s%15s\n', 'Reduction', 'Nodes', errorMetric);
  for limit = reductionLimit
    two = Temperature(options.temperatureOptions, ...
      'reduceModelOrder', Options('threshold', 0, 'limit', limit));
    Ttwo = Utils.toCelsius(two.compute(options.dynamicPower));

    error = Error.compute(errorMetric, Tone, Ttwo);
    fprintf('%15.2f%15s%15.4f\n', limit, ...
      sprintf('%3d /%3d', two.nodeCount, one.nodeCount), error);

    if error < minimalError, break; end
  end

  time = options.timeLine;

  for i = 1:options.processorCount
    color = Color.pick(i);
    line(time, Tone(i, :), 'Color', color);
    line(time, Ttwo(i, :), 'Color', color, 'LineStyle', '--');
  end

  Plot.title('%s: %d/%d nodes: %s %.4f', ...
    class(one), one.nodeCount, two.nodeCount, errorMetric, error);
  Plot.label('Time, s', 'Temperature, C');
  Plot.limit(time);
end