function gqn_sparse_test ( )

%*****************************************************************************80
%
%% GQN_SPARSE_TEST uses the GQN function to build a sparse grid.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    07 April 2012
%
%  Author:
%
%    Original MATLAB version by Florian Heiss, Viktor Winschel.
%    This MATLAB version by John Burkardt.
%
%  Local parameters:
%
%    Local, integer D, the spatial dimension.
%
%    Local, integer MAXK, the maximum level to check.
%
  maxk = 4;

  d = 5;
  m = 6;
  func = 'x(:,1).^6';
  trueval = fn_integral ( d );

  fprintf ( 1, '\n' );
  fprintf ( 1, 'GQN_SPARSE_TEST:\n' );
  fprintf ( 1, '  GQN sparse grid:\n' );
  fprintf ( 1, '  Gauss quadrature, Hermite weight over (-oo,+oo).\n' );
  fprintf ( 1, '\n' );
  fprintf ( 1, '   D  Level   Nodes    SG error    MC error\n' );
  fprintf ( 1, '\n' );

  for k = 2 : maxk
%
%  Compute sparse grid estimate.
%
    [x w] = nwspgr ( 'gqn', d, k );
    g = eval(func);
    SGappr = g'*w;
    SGerror = sqrt((SGappr - trueval).^2)/trueval;
%
%  Compute 1000 Monte Carlo estimate with same number of points, and average.
%
    numnodes = length(w);
    sim = zeros(1000,1);
    for r=1:1000
      x = randn(numnodes,d);
      g = eval ( func );
      sim(r) = mean ( g );
    end
    Simerror = sqrt(mean((sim-trueval).^2))/trueval;

    fprintf( '  %2d     %2d  %6d  %10.5g  %10.5g\n', d, k, numnodes, SGerror, Simerror )

  end

  return
end
