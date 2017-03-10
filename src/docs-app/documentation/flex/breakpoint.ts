type breakpoint = {
  name: string;
  value: string;
};

const breakPointReadmeFilter = function(copy: string, breakpoints: breakpoint[]) {
  if (!breakpoints) {
    return copy;
  }

  return copy.replace(/(`\.[\w-]+(?=xx)[\w-]+`(?=\s)(?!\|))/g, match => {
    return breakpoints
      .map(breakpoint => match.replace("xx", breakpoint.name))
      .join("<br>");
  });
};

export { breakpoint, breakPointReadmeFilter };
