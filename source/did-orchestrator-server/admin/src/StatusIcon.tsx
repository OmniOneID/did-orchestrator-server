import React from "react";
import GreenStatusIcon from "./icons/GreenStatusIcon";
import RedStatusIcon from "./icons/RedStatusIcon";
import YellowStatusIcon from "./icons/YellowStatusIcon";
import ProgressIcon from "./icons/ProgressIcon";
import GrayStatusIcon from "./icons/GrayStatusIcon";

const StatusIcon = (statusString: string): JSX.Element => {
  switch (statusString) {
    case "GRAY":
        return <GrayStatusIcon />;
    case "GREEN":
      return <GreenStatusIcon />;
    case "YELLOW":
      return <YellowStatusIcon />;
    case "RED":
        return <RedStatusIcon />;
    case "PROGRESS":
      return <ProgressIcon />;
    default:
      return <RedStatusIcon />;
  }
};

export default StatusIcon;
