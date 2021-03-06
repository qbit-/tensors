function [indx, B, diffB] = update_indices (indx, B, A, k, l)
	 
	 ## usage: [indx, B] = update_indices (indx, B, A, k, l)
	 ## 
	 ## update vector p and a matrix B
	 ## B(k,l) contains sums of squares 
	 ## of an element (k,l) in the set of matrices A
	 ##
	 ## indx are column indices of the maximal elements in each
         ## row of B.
	 ## 
	 ## difference between the last and current B is returned in
	 ## diffB.
 
  matsz = size(A,1);
  nmat = size(A,3);

  ## update rows
  for n = [k l]
    for j=1:matsz
      indA = j:matsz:matsz*nmat;
      B(n,j) = norm(A(n,indA),'fro')^2;
    end
  end

  ## update columns
  for n = [k l]
    for j=1:matsz
      indA = j:matsz:matsz*nmat;
      B(j,n) = norm(A(n,indA),'fro')^2;
    end
  end
 
  for n = [k l]
    indx(n) = maxcol(B, n);
  end

endfunction
