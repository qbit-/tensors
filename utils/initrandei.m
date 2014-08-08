function EI = initrandei (dim, cplx, isym)
	 
	 ## usage: EI = initrandei (dim, cplx, isym)
	 ## returns random integrals in the Mulliken or Dirak ordering 
	 ##  
	 ## isym = 1 Mulliken
         ##           2 Dirak
	 ##      

  if ( cplx == 1 )
    EI = rand(dim,dim,dim,dim) + i*rand(dim,dim,dim,dim);
  else
    EI = rand(dim,dim,dim,dim);
  endif

  ET=EI;

  if ( isym == 1 )
  ## symmetrize (ij|kl) = (kl|ij) = (ji|lk)^* = (lk|ji)^*

    if ( cplx == 1 )
      for i = 1 : dim
	for j = 1 : dim
	  for k = 1 : dim
	    for l = 1 : dim
	      EI(i,j,k,l) = (ET(i,j,k,l) + ET(k,l,i,j) + \
			     conj(ET(j,i,l,k)) + conj(ET(l,k,j,i)))/4;		
	    end
	  end
	end
      end
      
  ## symmetrize (ij|kl) = (kl|ij) = (ji|lk) = (lk|ji) =
  ## and also   (ji|kl) = (lk|ij) = (ij|lk) = (kl|ij) 

    else
      for i = 1 : dim
	for j = 1 : dim
	  for k = 1 : dim
	    for l = 1 : dim
	      EI(i,j,k,l) = (ET(i,j,k,l) + ET(k,l,i,j) + \
			     ET(j,i,l,k) + ET(l,k,j,i))/4;	
	    end
	  end
	end
      end
      
    endif
 
  elseif ( isym == 2 )

  ## symmetrize <ij|kl> = <ji|lk> = <kl|ij>^* = <lk|ji>^*

    if ( cplx == 1 )
      for i = 1 : dim
	for j = 1 : dim
	  for k = 1 : dim
	    for l = 1 : dim
	      EI(i,k,j,l) = (ET(i,k,j,l) + ET(k,i,l,j) + \
			     conj(ET(j,l,i,k)) + conj(ET(l,j,k,i)))/4;		
	    end
	  end
	end
      end
      
  ## symmetrize <ij|kl> = <ji|lk> = <kl|ij> = <lk|ji> =
  ## and also   <kj|il> = <li|jk> = <il|kj> = <jk|li> 

    else
      for i = 1 : dim
	for j = 1 : dim
	  for k = 1 : dim
	    for l = 1 : dim
	      EI(i,k,j,l) = (ET(i,k,j,l) + ET(k,i,l,j) + \
			     ET(j,l,i,k) + ET(l,j,k,i))/4;		

	    end
	  end
	end
      end
      
    endif

  endif

endfunction
