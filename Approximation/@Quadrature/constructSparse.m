function [ nodes, weights ] = constructSparse(this, options)
  dimension = options.dimension;
  maxLevel = options.level;

  ruleName = options.ruleName;
  ruleArguments = options.get('ruleArguments', {});

  minLevel = max(0, maxLevel - dimension + 1);

  pointSet = zeros(1, maxLevel);
  nodeSet = cell(maxLevel);
  weightSet = cell(maxLevel);

  %
  % Compute one-dimensional rules for all the needed levels.
  %
  for level = 1:maxLevel
    [ nodeSet{level}, weightSet{level} ] = ...
      feval(ruleName, level, ruleArguments{:});
    pointSet(level) = length(weightSet{level});
  end

  points = 0;
  nodes = [];
  weights = [];

  for level = minLevel:maxLevel
    coefficient = (-1)^(maxLevel - level) * ...
      nchoosek(dimension - 1, maxLevel - level);

    %
    % Compute all combinations of positive integers that
    % sum up to `dimension + level - 1'.
    %
    indexSet = get_seq(dimension, dimension + level - 1);

    newPoints = prod(pointSet(indexSet), 2);
    totalNewPoints = sum(newPoints);

    %
    % Preallocate space for new points.
    %
    nodes = [ nodes; zeros(totalNewPoints, dimension) ];
    weights = [ weights; zeros(totalNewPoints, 1) ];

    %
    % Append the new nodes and weights.
    %
    for i = 1:size(indexSet, 1)
      index = indexSet(i, :);

      [ newNodes, newWeights ] = ...
        tensor_product(nodeSet(index), weightSet(index));

      nodes((points + 1):(points + newPoints(i)), :) = newNodes;
      weights((points + 1):(points + newPoints(i))) = coefficient * newWeights;

      points = points + newPoints(i);
    end

    %
    % Merge repeated values.
    %
    while true
      done = true;
      for i = 1:size(nodes, 1)
        I = find(all(abs(bsxfun(@minus, nodes, nodes(i, :))) < sqrt(2) * eps, 2));
        if length(I) == 1, continue; end
        done = false;
        weights(I(1)) = sum(weights(I));
        nodes(I(2:end), :) = [];
        weights(I(2:end)) = [];
        break;
      end
      if done, break; end
    end
  end

  %
  % NODE: In order to compare this implementation with the algorithm
  % from SPARSE_GRID_HW by John Brurkardt, we need to sort the nodes.
  %
  % nodes(abs(nodes) < sqrt(2) * eps) = 0;
  %
  % [ nodes, I ] = sortrows(nodes);
  % weights = weights(I);
  %

  %
  % Normalize the weights.
  %
  weights = weights / sum(weights);
end