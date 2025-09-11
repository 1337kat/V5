--[[
trajectory(
	
	origin: Vector3,
	projectileSpeed: number,
	targetPos: Vector3,
	targetVelocity: Vector3,
	pickLongest: bool,
	gravity: number
)
]]

local a={}
local b=(function()local c=math.abs;local d=math.sqrt;local e=math.acos;local f=math.cos;local g=1e-9;local function h(i)return i>-g and i<g end;local function j(k)return k>0 and k^(1/3)or-c(k)^(1/3)end;local function l(m,n,o)local p,q;local r,s,t;r=n/(2*m)s=o/m;t=r*r-s;if h(t)then p=-r;return p elseif t<0 then return else local u=d(t)p=u-r;q=-u-r;return p,q end end;local function v(m,n,o,w)local p,q,x;local y,z;local A,B,C;local D,r,s;local E,t;A=n/m;B=o/m;C=w/m;D=A*A;r=1/3*(-(1/3)*D+B)s=0.5*(2/27*A*D-1/3*A*B+C)E=r*r*r;t=s*s+E;if h(t)then if h(s)then p=0;y=1 else local F=j(-s)p=2*F;q=-F;y=2 end elseif t<0 then local G=1/3*e(-s/d(-E))local H=2*d(-r)p=H*f(G)q=-H*f(G+pi/3)x=-H*f(G-pi/3)y=3 else local u=d(t)local F=j(u-s)local I=-j(u+s)p=F+I;y=1 end;z=1/3*A;if y>0 then p=p-z end;if y>1 then q=q-z end;if y>2 then x=x-z end;return p,q,x end;local function J(m,n,o,w,K)local p,q,x,L;local M={}local N,F,I,z;local A,B,C,t;local D,r,s,O;local y;A=n/m;B=o/m;C=w/m;t=K/m;D=A*A;r=-0.375*D+B;s=0.125*D*A-0.5*A*B+C;O=-(3/256)*D*D+0.0625*D*B-0.25*A*C+t;if h(O)then M[3]=s;M[2]=r;M[1]=0;M[0]=1;local P={v(M[0],M[1],M[2],M[3])}y=#P;p,q,x=P[1],P[2],P[3]else M[3]=0.5*O*r-0.125*s*s;M[2]=-O;M[1]=-0.5*r;M[0]=1;p,q,x=v(M[0],M[1],M[2],M[3])N=p;F=N*N-O;I=2*N-r;if h(F)then F=0 elseif F>0 then F=d(F)else return end;if h(I)then I=0 elseif I>0 then I=d(I)else return end;M[2]=N-F;M[1]=s<0 and-I or I;M[0]=1;do local P={l(M[0],M[1],M[2])}y=#P;p,q=P[1],P[2]end;M[2]=N+F;M[1]=s<0 and I or-I;M[0]=1;if y==0 then local P={l(M[0],M[1],M[2])}y=y+#P;p,q=P[1],P[2]end;if y==1 then local P={l(M[0],M[1],M[2])}y=y+#P;q,x=P[1],P[2]end;if y==2 then local P={l(M[0],M[1],M[2])}y=y+#P;x,L=P[1],P[2]end end;z=0.25*A;if y>0 then p=p-z end;if y>1 then q=q-z end;if y>2 then x=x-z end;if y>3 then L=L-z end;return{L,x,q,p}end;return J end)()
function a.trajectory(Q,R,S,T,U,V)local W=V or workspace.Gravity;local X=S-Q;local r,s,O=T.X,T.Y,T.Z;local Y,Z,_=X.X,X.Y,X.Z;local a0=-.5*W;local a1=b(a0*a0,-2*s*a0,s*s-2*Z*a0-R*R+r*r+O*O,2*Z*s+2*Y*r+2*_*O,Z*Z+Y*Y+_*_)if a1 then local a2=table.create(2)for a3,I in a1 do if I>0 then table.insert(a2,I)end end;if a2[1]then local H=a2[U and 2 or 1]local i=(Y+r*H)/H;local a4=(Z+s*H-a0*H*H)/H;local a5=(_+O*H)/H;return Q+Vector3.new(i,a4,a5)end end;return end;
return a
