local a={}local b={}local unpack=rawget(table,"unpack")or unpack;local c=function(d,...)if d==nil then return nil end;return...end;local e=function(f,d,...)if d==nil then return nil end;return d,f(...)end;local function g(h)local i=type(h)local j;if i=='table'then j={}for k,l in next,h,nil do j[g(k)]=g(l)end else j=h end;return j end;local m={__call=function(self,n,o)return self.gen(n,o)end,__tostring=function(self)return'<generator>'end,__index=b}local p=function(q,n,o)return setmetatable({gen=q,param=n,state=o},m),n,o end;a.wrap=p;local r=function(self)return self.gen,self.param,self.state end;b.unwrap=r;local s=function(t,u)return nil end;local v=function(n,o)local o=o+1;if o>#n then return nil end;local w=string.sub(n,o,o)return o,w end;local x=pairs({a=0})local y=function(z,A)local B;local A,B=x(z,A)return A,A,B end;local C=function(D,n,o)assert(D~=nil,"invalid iterator")if type(D)=="table"then local E=getmetatable(D)if E~=nil then if E==m then return D.gen,D.param,D.state elseif E.__ipairs~=nil then return E.__ipairs(D)elseif E.__pairs~=nil then return E.__pairs(D)end end;if#D>0 then return ipairs(D)else return y,D,nil end elseif type(D)=="function"then return D,n,o elseif type(D)=="string"then if#D==0 then return s,nil,nil end;return v,D,0 end;error(string.format('object %s of type "%s" is not iterable',D,type(D)))end;local F=function(D,n,o)return p(C(D,n,o))end;a.iter=F;local G=function(f)return function(self)return f(self.gen,self.param,self.state)end end;local H=function(f)return function(self,I)return f(I,self.gen,self.param,self.state)end end;local J=function(f)return function(self,I,K)return f(I,K,self.gen,self.param,self.state)end end;local L=function(f)return function(q,n,o)return f(C(q,n,o))end end;local M=function(f)return function(I,q,n,o)return f(I,C(q,n,o))end end;local N=function(f)return function(I,K,q,n,o)return f(I,K,C(q,n,o))end end;local O=function(f,q,n,o)repeat o=e(f,q(n,o))until o==nil end;b.each=H(O)a.each=M(O)b.for_each=b.each;a.for_each=a.each;b.foreach=b.each;a.foreach=a.each;local P=function(n,o)local Q,R=n[1],n[2]local o=o+R;if o>Q then return nil end;return o,o end;local S=function(n,o)local Q,R=n[1],n[2]local o=o+R;if o<Q then return nil end;return o,o end;local T=function(U,Q,R)if R==nil then if Q==nil then if U==0 then return s,nil,nil end;Q=U;U=Q>0 and 1 or-1 end;R=U<=Q and 1 or-1 end;assert(type(U)=="number","start must be a number")assert(type(Q)=="number","stop must be a number")assert(type(R)=="number","step must be a number")assert(R~=0,"step must not be zero")if R>0 then return p(P,{Q,R},U-R)elseif R<0 then return p(S,{Q,R},U-R)end end;a.range=T;local V=function(W,d)return d+1,unpack(W)end;local X=function(W,d)return d+1,W(d)end;local Y=function(W,d)return d+1,W end;local Z=function(...)if select('#',...)<=1 then return p(Y,select(1,...),0)else return p(V,{...},0)end end;a.duplicate=Z;a.replicate=Z;a.xrepeat=Z;local _=function(f)assert(type(f)=="function")return p(X,f,0)end;a.tabulate=_;local a0=function()return p(Y,0,0)end;a.zeros=a0;local a1=function()return p(Y,1,0)end;a.ones=a1;local a2=function(W,a3)return 0,math.random(W[1],W[2])end;local a4=function(a5,a3)return 0,math.random()end;local a6=function(a7,a8)if a7==nil and a8==nil then return p(a4,0,0)end;assert(type(a7)=="number","invalid first arg to rands")if a8==nil then a8=a7;a7=0 else assert(type(a8)=="number","invalid second arg to rands")end;assert(a7<a8,"empty interval")return p(a2,{a7,a8-1},0)end;a.rands=a6;local a9=function(a7,aa,W,d)assert(a7>0,"invalid first argument to nth")if aa==ipairs then return W[a7]elseif aa==v then if a7<=#W then return string.sub(W,a7,a7)else return nil end end;for ab=1,a7-1,1 do d=aa(W,d)if d==nil then return nil end end;return c(aa(W,d))end;b.nth=H(a9)a.nth=M(a9)local ac=function(o,...)if o==nil then error("head: iterator is empty")end;return...end;local ad=function(q,n,o)return ac(q(n,o))end;b.head=G(ad)a.head=L(ad)a.car=a.head;b.car=b.head;local ae=function(q,n,o)o=q(n,o)if o==nil then return p(s,nil,nil)end;return p(q,n,o)end;b.tail=G(ae)a.tail=L(ae)a.cdr=a.tail;b.cdr=b.tail;local af=function(ab,d,...)if d==nil then return nil end;return{ab,d},...end;local ag=function(n,o)local a7,aa,W=n[1],n[2],n[3]local ab,d=o[1],o[2]if ab>=a7 then return nil end;return af(ab+1,aa(W,d))end;local ah=function(a7,q,n,o)assert(a7>=0,"invalid first argument to take_n")return p(ag,{a7,q,n},{0,o})end;b.take_n=H(ah)a.take_n=M(ah)local ai=function(f,d,...)if d==nil or not f(...)then return nil end;return d,...end;local aj=function(n,d)local f,aa,W=n[1],n[2],n[3]return ai(f,aa(W,d))end;local ak=function(f,q,n,o)assert(type(f)=="function","invalid first argument to take_while")return p(aj,{f,q,n},o)end;b.take_while=H(ak)a.take_while=M(ak)local al=function(am,q,n,o)if type(am)=="number"then return ah(am,q,n,o)else return ak(am,q,n,o)end end;b.take=H(al)a.take=M(al)local an=function(a7,q,n,o)assert(a7>=0,"invalid first argument to drop_n")local ab;for ab=1,a7,1 do o=q(n,o)if o==nil then return p(s,nil,nil)end end;return p(q,n,o)end;b.drop_n=H(an)a.drop_n=M(an)local ao=function(f,d,...)if d==nil or not f(...)then return d,false end;return d,true,...end;local ap=function(f,aa,W,d)assert(type(f)=="function","invalid first argument to drop_while")local aq,ar;repeat ar=g(d)d,aq=ao(f,aa(W,d))until not aq;if d==nil then return p(s,nil,nil)end;return p(aa,W,ar)end;b.drop_while=H(ap)a.drop_while=M(ap)local as=function(am,aa,W,d)if type(am)=="number"then return an(am,aa,W,d)else return ap(am,aa,W,d)end end;b.drop=H(as)a.drop=M(as)local at=function(am,aa,W,d)return al(am,aa,W,d),as(am,aa,W,d)end;b.split=H(at)a.split=M(at)b.split_at=b.split;a.split_at=a.split;b.span=b.split;a.span=a.split;local au=function(av,q,n,o)local ab=1;for aw,w in q,n,o do if w==av then return ab end;ab=ab+1 end;return nil end;b.index=H(au)a.index=M(au)b.index_of=b.index;a.index_of=a.index;b.elem_index=b.index;a.elem_index=a.index;local ax=function(n,o)local av,aa,W=n[1],n[2],n[3]local ab,d=o[1],o[2]local w;while true do d,w=aa(W,d)if d==nil then return nil end;ab=ab+1;if w==av then return{ab,d},ab end end end;local ay=function(av,q,n,o)return p(ax,{av,q,n},{0,o})end;b.indexes=H(ay)a.indexes=M(ay)b.elem_indexes=b.indexes;a.elem_indexes=a.indexes;b.indices=b.indexes;a.indices=a.indexes;b.elem_indices=b.indexes;a.elem_indices=a.indexes;local az=function(f,aa,W,d,aA)while true do if d==nil or f(aA)then break end;d,aA=aa(W,d)end;return d,aA end;local aB;local aC=function(f,aa,W,d)return aB(f,aa,W,aa(W,d))end;aB=function(f,aa,W,d,...)if d==nil then return nil end;if f(...)then return d,...end;return aC(f,aa,W,d)end;local aD=function(f,aa,W,d,...)if select('#',...)<2 then return az(f,aa,W,d,...)else return aB(f,aa,W,d,...)end end;local aE=function(n,d)local f,aa,W=n[1],n[2],n[3]return aD(f,aa,W,aa(W,d))end;local aF=function(f,q,n,o)return p(aE,{f,q,n},o)end;b.filter=H(aF)a.filter=M(aF)b.remove_if=b.filter;a.remove_if=a.filter;local aG=function(aH,q,n,o)local f=aH;if type(aH)=="string"then f=function(av)return string.find(av,aH)~=nil end end;return aF(f,q,n,o)end;b.grep=H(aG)a.grep=M(aG)local aI=function(f,q,n,o)local aJ=function(...)return not f(...)end;return aF(f,q,n,o),aF(aJ,q,n,o)end;b.partition=H(aI)a.partition=M(aI)local aK=function(f,U,o,...)if o==nil then return nil,U end;return o,f(U,...)end;local aL=function(f,U,aa,W,d)while true do d,U=aK(f,U,aa(W,d))if d==nil then break end end;return U end;b.foldl=J(aL)a.foldl=N(aL)b.reduce=b.foldl;a.reduce=a.foldl;local aM=function(q,n,o)if q==ipairs or q==v then return#n end;local aN=0;repeat o=q(n,o)aN=aN+1 until o==nil;return aN-1 end;b.length=G(aM)a.length=L(aM)local aO=function(q,n,o)return q(n,g(o))==nil end;b.is_null=G(aO)a.is_null=L(aO)local aP=function(aQ,aR)local aa,W,d=F(aQ)local aS,aT,aU=F(aR)local aV,aW;for ab=1,10,1 do d,aV=aa(W,d)aU,aW=aS(aT,aU)if d==nil then return true end;if aU==nil or aV~=aW then return false end end end;b.is_prefix_of=aP;a.is_prefix_of=aP;local aX=function(f,aa,W,d)local w;repeat d,w=e(f,aa(W,d))until d==nil or not w;return d==nil end;b.all=H(aX)a.all=M(aX)b.every=b.all;a.every=a.all;local aY=function(f,aa,W,d)local w;repeat d,w=e(f,aa(W,d))until d==nil or w;return not not w end;b.any=H(aY)a.any=M(aY)b.some=b.any;a.some=a.any;local aZ=function(q,n,o)local a_=0;local w=0;repeat a_=a_+w;o,w=q(n,o)until o==nil;return a_ end;b.sum=G(aZ)a.sum=L(aZ)local b0=function(q,n,o)local b1=1;local w=1;repeat b1=b1*w;o,w=q(n,o)until o==nil;return b1 end;b.product=G(b0)a.product=L(b0)local b2=function(a8,a7)if a7<a8 then return a7 else return a8 end end;local b3=function(a8,a7)if a7>a8 then return a7 else return a8 end end;local b4=function(q,n,o)local o,a8=q(n,o)if o==nil then error("min: iterator is empty")end;local b5;if type(a8)=="number"then b5=math.min else b5=b2 end;for b6,w in q,n,o do a8=b5(a8,w)end;return a8 end;b.min=G(b4)a.min=L(b4)b.minimum=b.min;a.minimum=a.min;local b7=function(b5,aa,W,d)local d,a8=aa(W,d)if d==nil then error("min: iterator is empty")end;for b6,w in aa,W,d do a8=b5(a8,w)end;return a8 end;b.min_by=H(b7)a.min_by=M(b7)b.minimum_by=b.min_by;a.minimum_by=a.min_by;local b8=function(aa,W,d)local d,a8=aa(W,d)if d==nil then error("max: iterator is empty")end;local b5;if type(a8)=="number"then b5=math.max else b5=b3 end;for b6,w in aa,W,d do a8=b5(a8,w)end;return a8 end;b.max=G(b8)a.max=L(b8)b.maximum=b.max;a.maximum=a.max;local b9=function(b5,aa,W,d)local d,a8=aa(W,d)if d==nil then error("max: iterator is empty")end;for b6,w in aa,W,d do a8=b5(a8,w)end;return a8 end;b.max_by=H(b9)a.max_by=M(b9)b.maximum_by=b.maximum_by;a.maximum_by=a.maximum_by;local ba=function(aa,W,d)local z,A,bb={}while true do d,bb=aa(W,d)if d==nil then break end;table.insert(z,bb)end;return z end;b.totable=G(ba)a.totable=L(ba)local bc=function(aa,W,d)local z,A,bb={}while true do d,A,bb=aa(W,d)if d==nil then break end;z[A]=bb end;return z end;b.tomap=G(bc)a.tomap=L(bc)local y=function(n,o)local aa,W,f=n[1],n[2],n[3]return e(f,aa(W,o))end;local bd=function(f,q,n,o)return p(y,{q,n,f},o)end;b.map=H(bd)a.map=M(bd)local be=function(o,ab,d,...)if d==nil then return nil end;return{ab+1,d},ab,...end;local bf=function(n,o)local aa,W=n[1],n[2]local ab,d=o[1],o[2]return be(o,ab,aa(W,d))end;local bg=function(q,n,o)return p(bf,{q,n},{1,o})end;b.enumerate=G(bg)a.enumerate=L(bg)local bh=function(ab,d,...)if d==nil then return nil end;return{ab+1,d},...end;local bi=function(n,o)local av,aa,W=n[1],n[2],n[3]local ab,d=o[1],o[2]if ab%2==1 then return{ab+1,d},av else return bh(ab,aa(W,d))end end;local bj=function(av,q,n,o)return p(bi,{av,q,n},{0,o})end;b.intersperse=H(bj)a.intersperse=M(bj)local function bk(n,o,bl,...)if#bl==#n/2 then return bl,...end;local ab=#bl+1;local aa,W=n[2*ab-1],n[2*ab]local d,w=aa(W,o[ab])if d==nil then return nil end;table.insert(bl,d)return bk(n,o,bl,w,...)end;local bm=function(n,o)return bk(n,o,{})end;local bn=function(...)local a7=select('#',...)if a7>=3 then local bo=select(a7-2,...)if type(bo)=='table'and getmetatable(bo)==m and bo.param==select(a7-1,...)and bo.state==select(a7,...)then return a7-2 end end;return a7 end;local bp=function(...)local a7=bn(...)if a7==0 then return p(s,nil,nil)end;local n={[2*a7]=0}local o={[a7]=0}local ab,aa,W,d;for ab=1,a7,1 do local bo=select(a7-ab+1,...)aa,W,d=C(bo)n[2*ab-1]=aa;n[2*ab]=W;o[ab]=d end;return p(bm,n,o)end;b.zip=bp;a.zip=bp;local bq=function(n,d,...)if d==nil then local aa,W,br=n[1],n[2],n[3]return aa(W,g(br))end;return d,...end;local bs=function(n,d)local aa,W,br=n[1],n[2],n[3]return bq(n,aa(W,d))end;local bt=function(q,n,o)return p(bs,{q,n,o},g(o))end;b.cycle=G(bt)a.cycle=L(bt)local bu;local bv=function(n,o,d,...)if d==nil then local ab=o[1]ab=ab+1;if ab>#n/3 then return nil end;local d=n[3*ab]return bu(n,{ab,d})end;return{o[1],d},...end;bu=function(n,o)local ab,d=o[1],o[2]local aa,W=n[3*ab-2],n[3*ab-1]return bv(n,o,aa(W,o[2]))end;local bw=function(...)local a7=bn(...)if a7==0 then return p(s,nil,nil)end;local n={[3*a7]=0}local ab,aa,W,d;for ab=1,a7,1 do local bx=select(ab,...)aa,W,d=F(bx)n[3*ab-2]=aa;n[3*ab-1]=W;n[3*ab]=d end;return p(bu,n,{1,n[3]})end;b.chain=bw;a.chain=bw;local by={lt=function(aA,bz)return aA<bz end,le=function(aA,bz)return aA<=bz end,eq=function(aA,bz)return aA==bz end,ne=function(aA,bz)return aA~=bz end,ge=function(aA,bz)return aA>=bz end,gt=function(aA,bz)return aA>bz end,add=function(aA,bz)return aA+bz end,div=function(aA,bz)return aA/bz end,floordiv=function(aA,bz)return math.floor(aA/bz)end,intdiv=function(aA,bz)local bA=aA/bz;if aA>=0 then return math.floor(bA)else return math.ceil(bA)end end,mod=function(aA,bz)return aA%bz end,mul=function(aA,bz)return aA*bz end,neq=function(aA)return-aA end,unm=function(aA)return-aA end,pow=function(aA,bz)return aA^bz end,sub=function(aA,bz)return aA-bz end,truediv=function(aA,bz)return aA/bz end,concat=function(aA,bz)return aA..bz end,len=function(aA)return#aA end,length=function(aA)return#aA end,land=function(aA,bz)return aA and bz end,lor=function(aA,bz)return aA or bz end,lnot=function(aA)return not aA end,truth=function(aA)return not not aA end}a.operator=by;b.operator=by;a.op=by;b.op=by;setmetatable(a,{__call=function(bB,bC)for bD,bE in pairs(bB)do if _G[bD]~=nil then local bF='function '..bD..' already exists in global scope.'if bC then _G[bD]=bE;print('WARNING: '..bF..' Overwritten.')else print('NOTICE: '..bF..' Skipped.')end else _G[bD]=bE end end end})fun=a;function fn(s,...)local bG="local L1,L2,L3,L4,L5,L6,L7,L8,L9=...return function(P1,P2,P3,P4,P5,P6,P7,P8,P9)return "..s.." end"return loadstring(bG)(...)end
