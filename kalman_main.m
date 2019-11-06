function [] = kalman_main()
  
  kq = 0.001;
  kr = 0.9;

  z = []
  for i=1:101
    z(i, 1) = i + randn();
    z(i, 2) = i + randn();
  end
  
  F = [1 1 0 0 0 0;
       0 1 1 0 0 0;
       0 0 1 0 0 0;
       0 0 0 1 1 0;
       0 0 0 0 1 1;
       0 0 0 0 0 1;];

  H = [1 0 0 0 0 0;
       0 0 0 1 0 0;];

  Q = eye(6)*kq;
  R = eye(2)*kr;
 
  P = zeros(6);

  estados(1, :)  = [z(1,1) 0 0 z(1, 2) 0 0];
  
  for i=2:101
    [estados(i,:), P] = Kalman(estados(i-1,:), P, F, H, Q, R, z(i,:)');
  end


  %z e o ruido 
  %x e a correta 
  %xe e o estimado

  pl = plot(z(:,1), z(:,2), 'r.-', estados(:, 1), estados(:, 4), 'b.-'); 
  waitfor(pl);
  
  %plot(1,101,xe(1,:),'-k',1,101,x,'-g',1,101,z,'-r');
  
  
end


function[x, P] = Kalman(x, P, F, H, Q, R, z)
  xa = F*x';                          % previsão a priori
  Pa = F*P*F' + Q;
  y = (z - H*xa);
  K = Pa*H'/(H*Pa*H' + R);
  x = xa + K*y;
  P = (eye(length(x)) - K*H)*Pa;
  x = x';
end

