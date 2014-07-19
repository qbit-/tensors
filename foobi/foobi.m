function [A, Ds] = foobi (T,nvemax,emtresh)
	 
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
  [Ds indD] = sort(diag(D),'descend'); 
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
  
  ## problem here
  P = formP(H);
  [L S R] = svds(P,nvec,1e-6);
  W = unpacktri(R);

  %% pre-whitening
#  [Qi w]= eig( W(:,1:nvec) );
#  W = Qi' * W;
#  for j = 1:nvec:nvec*nvec
#      indW = [j:j+nvec-1];
#      W(:,indW) = W(:,indW) * Qi;
#  end

  %% joint diagonalization
#  [Q D] = joint_diag(W,1e-6);

  [Q D] = jacobi(W,1e-8);

#  Q = Qi * Q;
  F = H * Q;
  A = decompF(F);

endfunction
