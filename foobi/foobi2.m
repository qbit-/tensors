function [A, Ds] = foobi2 (T,nvemax,emtresh)
	 
	 ## usage: [U, lambda] = foobi (T)
	 ## 
	 ## Decompose 4-order tensor (Dirak symmetries)
	 
  dimin = size(T,4);

  if (~exist('emtresh','var'))
    emtresh = 1e-8;
  endif

  if (~exist('nvemax','var'))
    nvemax = 6;
  endif
  
  if (nvemax > dimin*dimin)
     nvemax = dimin*dimin;
     warning('setting nvemax to maximal possible rank %d', dimin*dimin);
  endif 
  
  C = reshape(T,dimin*dimin, dimin*dimin);

  [U D] = eig(C);
  [Ds indD] = sort(real(diag(D)),'descend'); 
  U = U(:,indD);
  
  %% truncation of non-significant eigenvalues and eigenvectors
  nvec = 1;
  for j = 1:nvemax
      if ( abs(Ds(j)) < emtresh ) 
	 nvec = j - 1;
	 break
      endif
      nvec = j;
  end

  H =  U(:,1:nvec) * diag(sqrt( Ds(1:nvec) ));

  H = norm_herm(H);
  
  B = formB(H);

  %% pre-whitening
  Qi = joint_offdiag(B(:,1:nvec),1e-6);
  B = Qi' * B;
  for j = 1:nvec:nvec*dimin*dimin*2
      indB = [j:j+nvec-1];
      B(:,indB) = B(:,indB) * Qi;
  end

  %% joint off-diagonalization
  [Q D] = joint_offdiag(B,1e-8);
  D
  
  Q = Qi * Q;
  F = H * Q;
  A = decompF(F);

endfunction
