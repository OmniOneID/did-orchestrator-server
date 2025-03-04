/*
 * Copyright 2025 OmniOne.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import React from "react";

interface HelpIconProps {
  width?: string;
  height?: string;
  style?: React.CSSProperties;
}

const HelpIcon: React.FC<HelpIconProps> = ({
  width = "1em",
  height = "1em",
  style = {},
}) => {
  return (
    <svg
      className="svg-icon"
      style={{
        width,
        height,
        verticalAlign: "middle",
        fill: "currentColor",
        overflow: "hidden",
        ...style,
      }}
      viewBox="0 0 1024 1024"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        d="M512 288c-72.72 0-128 48-128 128h80c0-32 16-64 48-64s51.2 19.872 47.28 51.648C553.456 450.896 464 466.176 464 549.792V576h80v-16c0-57.44 96-77.088 96-160 0-64-54.56-112-128-112z m-48 416h80v-80h-80v80z m40-608c-108.992 0-211.456 42.448-288.496 119.504C138.432 292.56 96 395.024 96 504 96 728.976 279.024 912 504 912h0.064c108.96 0 211.408-42.448 288.48-119.504C869.552 715.44 912 612.976 912 504 912 279.024 728.976 96 504 96z m234.16 642.144a328.832 328.832 0 0 1-234.08 96.96H504c-182.56 0-331.12-148.528-331.12-331.104a329.024 329.024 0 0 1 96.96-234.144A329.04 329.04 0 0 1 504 172.88c182.56 0 331.12 148.544 331.12 331.12a329.04 329.04 0 0 1-96.96 234.144z"
        fill="#565D64"
      />
    </svg>
  );
};

export default HelpIcon;
