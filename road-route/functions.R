
#Get nearest distance ----
get.dist=function(user.coords,grid1){
  dist.mat=matrix(NA,nrow(user.coords)-1,nrow(grid1))
  ngrid=nrow(grid1)
  for (i in 2:nrow(user.coords)){
    y0=user.coords$y[i]
    y1=user.coords$y[i-1]
    x0=user.coords$x[i]
    x1=user.coords$x[i-1]
    delta.x=(x0-x1)
    delta.y=(y0-y1)
    
    #diagonal line
    if (delta.x!=0 & delta.y!=0){
      #key parameters
      b=delta.y/delta.x
      a=y0-b*x0
      s=-1/b
      
      #closest point in line
      xs=((grid1$y-s*grid1$x)-a)/(b-s)
      ys=a+b*xs
      
      #check if within segment
      cond=xs>x0 & xs<x1
      if (delta.x>0) cond=xs<x0 & xs>x1
    }
    
    #vertical line
    if (delta.x==0){ 
      xs=rep(x0,ngrid)
      ys=grid1$y
      
      #check if within segment
      cond=ys>y0 & ys<y1
      if (delta.y>0) cond=ys<y0 & ys>y1
    }
    
    #horizontal line
    if (delta.y==0){ 
      xs=grid1$x
      ys=rep(y0,ngrid)
      
      #check if within segment
      cond=xs>x0 & xs<x1
      if (delta.x>0) cond=xs<x0 & xs>x1
    }
    
    #if within segment
    xsq=(grid1$x[cond]-xs[cond])^2
    ysq=(grid1$y[cond]-ys[cond])^2
    dist.mat[i-1,cond]=sqrt(xsq+ysq)
    
    #if outside segment
    xsq0=(grid1$x[!cond]-x0)^2
    ysq0=(grid1$y[!cond]-y0)^2
    dist0=sqrt(xsq0+ysq0)
    xsq1=(grid1$x[!cond]-x1)^2
    ysq1=(grid1$y[!cond]-y1)^2
    dist1=sqrt(xsq1+ysq1)
    dist.fim=apply(cbind(dist0,dist1),1,min)
    dist.mat[i-1,!cond]=dist.fim
  }
  
  apply(dist.mat,2,min)
}

# Get length ----
get.length=function(user.coords){
  length1=rep(NA,nrow(user.coords)-1)
  for (i in 2:nrow(user.coords)){
    ydif=user.coords$y[i]-user.coords$y[i-1]
    xdif=user.coords$x[i]-user.coords$x[i-1]
    length1[i-1]=sqrt((ydif^2)+(xdif^2))
  }
  sum(length1)  
}

# Calculate expected deforested area of UA (d.ua) and of PA (d.pa) ----
calc.deforest=function(grid1){
  cond=grid1$tipo=='PA'
  d.pa=sum(grid1$prob[cond])
  d.pa.prop=sum(grid1$prob[cond])/sum(cond)
  cond=grid1$tipo=='Forest'
  d.ua=sum(grid1$prob[cond])
  d.ua.prop=sum(grid1$prob[cond])/sum(cond)
  list(d.pa=d.pa,d.ua=d.ua, d.pa.prop=d.pa.prop, d.ua.prop=d.ua.prop)
}

# Calculate expected cost ----
get.cost=function(grid1, road.cost, pa.cost, forest.cost, protect, rd.length){
  tmp=calc.deforest(grid1)
  ecost=list(pa.cost=pa.cost*tmp$d.pa*(1-protect),
             road.cost=road.cost*rd.length,
             forest.cost=forest.cost*tmp$d.ua,
             d.pa.prop=tmp$d.pa.prop*(1-protect),
             d.ua.prop=tmp$d.ua.prop)
  return(ecost)
}

# Calculate deforestation probability ----
def.prob <- function (grid1, coef1) {
  tmp=exp(coef1['(Intercept)']+coef1['dist_road']*grid1$dist_road+
            coef1['dist_uc']*grid1$dist_uc+
            coef1['dist_road:dist_uc']*grid1$dist_road*grid1$dist_uc)
  tmp/(1+tmp)
}

# Validate input ----
# if empty or non numeric, make them zero
check.input <- function (x) {
  x <- as.numeric(x)
  if (length(x)==0 | is.na(x)) {
    x <- 0
  }
  return(x)
}