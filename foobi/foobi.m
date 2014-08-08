function [A O] = foobi (T,isym,emtresh)
	 
	 ## usage: [U, lambda] = foobi (T)
	 ## 
	 ## Decompose 4-order tensor (Dirak symmetries)
	 ## isym - symmetry of the input tensor
	 ##      = 0 (default) - cumulant
         ##      = 1 Mulliken
	 ##      = 2 Dirak

  dimin = size(T,4);

  if (~exist('isym','var'))
     isym = 0;
     warning('using cumulant symmetry by default');
  endif 

  if (~exist('emtresh','var'))
    emtresh = 1e-8;
  endif

  C = reshape(T,dimin*dimin, dimin*dimin);

#  if ( (isym == 0) || (isym == 2) )
#    [U D] = eig(C);
#  else
    [U, D, ~] = svd(C);
#  end

  %% Warning! have to check that eigenvalues are real each time
  [Ds indD] = sort(real(diag(D)),'descend'); 
  U = U(:,indD);
  
  %% truncation of non-significant eigenvalues and eigenvectors
  nvec = 1;
  for j = 1:dimin*dimin
      if ( abs(Ds(j)) < emtresh ) 
	 nvec = j - 1;
	 break
      endif
      nvec = j;
  end

  fprintf(stdout, 'foobi: The rank is %d\n', nvec);

#  H =  U(:,1:nvec) * diag(sqrt( Ds(1:nvec) ));
  H =  U(:,1:nvec) * diag( Ds(1:nvec) );

  H = norm_herm(H);

#  P = formP_full(H); %% check this!
  P = formP(H);
  
  %% since we do full svd we take only nvec right sing. vectors

  [~, ~, R] = svd(P);
  R = R(:,end:-1:end - nvec + 1);

  M  = unpackM(R);
  Q  = cpd3_sgsd(M,{eye(nvec),eye(nvec),eye(nvec)},struct('TolFun',1e-8));

  #W = unpacktri(R(:,1:nvec));

  F = H * Q{1};
  [A O] = decompF(F);

endfunction
