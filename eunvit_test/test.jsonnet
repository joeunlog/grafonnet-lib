
local Base = {
  f: 2,
  g: self.f + 100,
};

local WrapperBase = {
  Base: Base,
};

{
  Derived: Base + {
    f: 5,
    old_f: super.f,
    old_g: super.g,
  },
  newDerived: Base + {
    f: 10,
    old_f: super.f,
    old_g: super.g,
  },
}