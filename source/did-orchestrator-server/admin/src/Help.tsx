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

import React, { useEffect, useState } from "react";
import ReactMarkdown from "react-markdown";

const HelpMarkdown: React.FC = () => {
  const [markdownContent, setMarkdownContent] = useState<string>("");

  useEffect(() => {
    fetch("https://raw.githubusercontent.com/OmniOneID/did-orchestrator-server/refs/heads/main/docs/manual/orchestrator_manual.md")
      .then((res) => res.text())
      .then((text) => setMarkdownContent(text))
      .catch((err) => console.error("Error fetching markdown:", err));
  }, []);

  const contextPath =  "https://raw.githubusercontent.com/OmniOneID/did-orchestrator-server/refs/heads/main/docs/manual/";

  return (
    <div className="prose prose-sm sm:prose-base lg:prose-lg xl:prose-xl" style={{ fontSize: "80%" }}>
        <ReactMarkdown
            children={markdownContent}
            components={{
                img: ({ node, ...props }) => {
                    const src = props.src || "";
                    const resolvedSrc =
                        src.startsWith("http") || src.startsWith("/")
                            ? src
                            : `${contextPath}${src}`;
                    return (
                        <img
                            {...props}
                            src={resolvedSrc}
                            alt={props.alt}
                            style={{
                                display: "inline",
                                verticalAlign: "middle",
                                maxWidth: "100%",
                                height: "auto",
                                margin: 0,
                                padding: 0,
                            }}
                        />
                    );
                },
            }}
        />
    </div>
  );
};

const Help: React.FC = () => {
  return (
    <div className="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center">
      <div className="bg-white w-[1000px] max-h-[80vh] p-6 rounded-lg shadow-lg overflow-y-auto">
        <h2 className="text-lg font-bold border-b pb-2 mb-4">
          OmniOne OpenDID Orchestrator Prerequisites
        </h2>
        <HelpMarkdown />
        <div className="flex justify-end mt-6">
          <button
            type="button"
            onClick={() => window.close()}
            className="px-4 py-2 bg-orange-500 text-white rounded"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
};

export default Help;
