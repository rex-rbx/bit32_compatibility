local bit32={}
local UINT32=0xFFFFFFFF
local BIT_COUNT=32
local function round(n)if n==nil then return 0 end if n>=0 then return math.floor(n+0.5) else return math.ceil(n-0.5) end end
local function u32(n)local r=round(n)%0x100000000 return r&UINT32 end
local function s32(n)local u=u32(n)if u>=0x80000000 then return u-0x100000000 else return u end end
local function disp_i(n)return round(n)end
local function rot(n)return(disp_i(n)%BIT_COUNT)&31 end
function bit32.band(...)local args={...}if #args==0 then return UINT32 end local r=UINT32 for i=1,#args do r=r&u32(args[i]) end return r&UINT32 end
function bit32.bor(...)local args={...}if #args==0 then return 0 end local r=0 for i=1,#args do r=r|u32(args[i]) end return r&UINT32 end
function bit32.bxor(...)local args={...}if #args==0 then return 0 end local r=0 for i=1,#args do r=r~u32(args[i]) end return r&UINT32 end
function bit32.bnot(x)return(~u32(x))&UINT32 end
function bit32.btest(...)return bit32.band(...)~=0 end
function bit32.lshift(x,disp)local n=disp_i(disp)if n==0 then return u32(x)end if n<0 then return bit32.rshift(x,-n)end if n>=BIT_COUNT then return 0 end return(u32(x)<<n)&UINT32 end
function bit32.rshift(x,disp)local n=disp_i(disp)if n==0 then return u32(x)end if n<0 then return bit32.lshift(x,-n)end if n>=BIT_COUNT then return 0 end local u=u32(x)return(u>>n)&UINT32 end
function bit32.arshift(x,disp)local n=disp_i(disp)if n==0 then return u32(x)end if n<0 then return bit32.lshift(x,-n)end local s=s32(x)if n>=BIT_COUNT then return(s<0)and UINT32 or 0 end local shifted=(s>>n)return shifted&UINT32 end
function bit32.lrotate(x,disp)local n=rot(disp)if n==0 then return u32(x)end local u=u32(x)return(((u<<n)|(u>>(BIT_COUNT-n)))&UINT32)end
function bit32.rrotate(x,disp)local n=rot(disp)if n==0 then return u32(x)end local u=u32(x)return(((u>>n)|(u<<(BIT_COUNT-n)))&UINT32)end
function bit32.extract(n,field,width)local f=round(field)local w=(width==nil)and 1 or round(width)if f<0 or w<=0 or f+w>BIT_COUNT then error("bit32.extract: field/width out of range")end local u=u32(n)local mask=((1<<w)-1)return((u>>f)&mask)end
function bit32.replace(n,v,field,width)local f=round(field)local w=(width==nil)and 1 or round(width)if f<0 or w<=0 or f+w>BIT_COUNT then error("bit32.replace: field/width out of range")end local u=u32(n)local val=u32(v)&((1<<w)-1)local mask=((1<<w)-1)<<f return((u&(~mask))|((val<<f)&mask))&UINT32 end
function bit32.byteswap(x)local u=u32(x)return(((u&0x000000FF)<<24)|((u&0x0000FF00)<<8)|((u&0x00FF0000)>>8)|((u&0xFF000000)>>24))&UINT32 end
function bit32.countlz(n)local u=u32(n)if u==0 then return 32 end local c=0 if(u&0xFFFF0000)==0 then c=c+16 u=u<<16 end if(u&0xFF000000)==0 then c=c+8 u=u<<8 end if(u&0xF0000000)==0 then c=c+4 u=u<<4 end if(u&0xC0000000)==0 then c=c+2 u=u<<2 end if(u&0x80000000)==0 then c=c+1 end return c end
function bit32.countrz(n)local u=u32(n)if u==0 then return 32 end local c=0 if(u&0x0000FFFF)==0 then c=c+16 u=u>>16 end if(u&0x000000FF)==0 then c=c+8 u=u>>8 end if(u&0x0000000F)==0 then c=c+4 u=u>>4 end if(u&0x00000003)==0 then c=c+2 u=u>>2 end if(u&0x00000001)==0 then c=c+1 end return c end
return bit32
