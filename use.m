function use(varargin)
  global executedSetups;

  if ~exist('executedSetups', 'var')
    executedSetups = {};
  end

  name = File.join(varargin{:});

  if File.isAbsolute(name)
    path = name;
  else
    path = File.join(File.trace, name);
  end

  hook = File.join(path, 'setup.m');

  if exist(path, 'dir')
    addpath(path);
    if ~any(ismember(executedSetups, hook)) && exist(hook, 'file')
      executedSetups{end + 1} = hook;
      run(hook);
    end
  else
    warning('An attempt to include a non-existing library "%s".', name);
  end
end
