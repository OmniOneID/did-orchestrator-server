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

interface TooltipProps {
  content: string;
  event: React.MouseEvent<HTMLButtonElement>;
}

const showToolTip = (content: string, event: React.MouseEvent<HTMLButtonElement>) => {
  event.preventDefault();
  const target = event.currentTarget;
  const rect = target.getBoundingClientRect();

  const tooltip = document.createElement("div");
  tooltip.className = "absolute bg-gray-700 text-white text-xs rounded py-1 px-2";
  tooltip.style.position = "absolute";
  tooltip.style.zIndex = "1000";
  tooltip.innerHTML = content;

  const top = rect.bottom + window.scrollY + 5;
  const left = rect.left + window.scrollX;
  tooltip.style.top = `${top}px`;
  tooltip.style.left = `${left}px`;

  document.body.appendChild(tooltip);

  setTimeout(() => tooltip.remove(), 3000);
};

export default showToolTip;
