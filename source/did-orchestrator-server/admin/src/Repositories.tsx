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

import React, { useState, forwardRef, useImperativeHandle, useEffect } from "react";
import ProgressIcon from "./icons/ProgressIcon";
import LogIcon from "./icons/LogIcon";
import StatusIcon from './StatusIcon';

interface Repository {
  id: string;
  name: string;
  status: string;
}

interface RepositoriesProps {
  openPopupLedger: (id: string) => void;
  onConfirmReset: (repoId: string) => void;
}

const defaultRepos: Repository[] = [
  { id: "postgre", name: "PostgreSQL", status: "GRAY" },
  { id: "fabric", name: "Hyperledger Fabric", status: "GRAY" },
  { id: "besu", name: "Hyperledger Besu", status: "GRAY" },
  { id: "lss", name: "Ledger Service Server", status: "GRAY" },
];

const Repositories = forwardRef((props: RepositoriesProps, ref) => {
  const { openPopupLedger } = props;
  const [repositories, setRepositories] = useState<Repository[]>(() => {
    const stored = localStorage.getItem("repositories");
    if (stored) {
      try {
        const parsed = JSON.parse(stored) as Repository[];
        if (parsed.length === 1 && parsed[0].id === "postgre") {
          return defaultRepos;
        }
        return parsed;
      } catch (e) {
        console.error("Error parsing repositories from localStorage", e);
      }
    }
    return [];
  });

  useEffect(() => {
    const alwaysInclude = ["postgre"];

    const stored = localStorage.getItem("repositories");
    const storedRepos = stored ? JSON.parse(stored) as Repository[] : [];
    fetch("/select")
        .then(res => res.json())
        .then(data => {
          const selected = data.selected;
          const selectedIds = selected ? [selected] : [];

          const finalSelected = Array.from(new Set([...selectedIds, ...alwaysInclude]));

          const filtered: Repository[] = defaultRepos
              .filter(repo => finalSelected.includes(repo.id))
              .map(repo => {
                const storedRepo = storedRepos.find(r => r.id === repo.id);
                return storedRepo ? { ...repo, status: storedRepo.status } : repo;
              });

          setRepositories(filtered);
          console.log("repositories : " +  JSON.stringify(filtered));
          localStorage.setItem("repositories", JSON.stringify(filtered));
        })
        .catch((err) => {
          console.error("Failed to fetch selectedRepositories from server:", err);
        });
  }, []);


// const Repositories = forwardRef((props: RepositoriesProps, ref) => {
//   const { openPopupLedger } = props;
//
//   const [repositories, setRepositories] = useState<Repository[]>(() => {
//
//   let selectedIds: string[] = [];
//   try {
//     const parsed = JSON.parse(localStorage.getItem("selectedRepositories") || "[]");
//     if (Array.isArray(parsed)) {
//       selectedIds = parsed;
//     }
//   } catch (e) {
//     console.error("Error parsing selectedRepositories:", e);
//   }
//
//   const alwaysInclude = ["postgre"];
//   const finalSelected = Array.from(new Set([...selectedIds, ...alwaysInclude]));
//
//   const stored = localStorage.getItem("repositories");
//   var baseRepos = [];
//   if (stored) {
//     baseRepos = JSON.parse(stored) as Repository[];
//     if(baseRepos.length == 1) { // postgre only case
//       baseRepos = defaultRepos;
//     }
//   } else {
//     baseRepos = defaultRepos;
//   }
//
//   const filteredRepos = baseRepos.filter(repo =>
//     finalSelected.includes(repo.id)
//   );
//
//   localStorage.setItem("repositories", JSON.stringify(filteredRepos));
//
//   try {
//     const stored = localStorage.getItem("repositories");
//     if (stored) {
//       const parsed = JSON.parse(stored) as Repository[];
//       const merged = parsed.filter(repo => finalSelected.includes(repo.id));
//       return merged.length > 0 ? merged : filteredRepos;
//     }
//   } catch (e) {
//     console.error("Error parsing repositories from localStorage", e);
//   }
//
//   return filteredRepos;
//
//   });

  useEffect(() => {
    localStorage.setItem("repositories", JSON.stringify(repositories));
  }, [repositories]);

  const healthCheck = async (repoId: string, fromUser: boolean = false) => {
    const currentRepo = repositories.find((repo) => repo.id === repoId);
    if (fromUser && currentRepo && currentRepo.status === "PROGRESS") {
      alert("The operation is currently in progress. Please try again later.");
      return;
    }

    /*
    setRepositories((prevRepos) =>
      prevRepos.map((repo) =>
        repo.id === repoId ? { ...repo, status: "PROGRESS" } : repo
      )
    );
    */

    try {
      const response = await fetch(`/healthcheck/${repoId}`, {
        method: "GET",
      });
      if (!response.ok) {
        throw new Error(`Failed to fetch health status for ${repoId}`);
      }
      const data = await response.json();
      setRepositories((prevRepos) =>
        prevRepos.map((repo) =>
          repo.id === repoId
            ? { ...repo, status: data.status === "UP" ? "GREEN" : "RED" }
            : repo
        )
      );
    } catch (error) {
      console.error("Error checking repository status:", error);
      setRepositories((prevRepos) =>
        prevRepos.map((repo) =>
          repo.id === repoId ? { ...repo, status: "RED" } : repo
        )
      );
    }
  };

  const startRepository = async (repoId: string, fromUser: boolean = false) => {
    const currentRepo = repositories.find((repo) => repo.id === repoId);
    if (fromUser && currentRepo && currentRepo.status === "PROGRESS") {
      alert("The operation is currently in progress. Please try again later.");
      return;
    }

    setRepositories((prevRepos) =>
      prevRepos.map((repo) =>
        repo.id === repoId ? { ...repo, status: "PROGRESS" } : repo
      )
    );

    try {
      const response = await fetch(`/startup/${repoId}`, {
        method: "GET",
      });
      if (response.ok) {
        console.log(`Repository ${repoId} started successfully`);
      } else {
        console.error(`Failed to start repository ${repoId}`);
      }
    } catch (error) {
      console.error("Error starting repository:", error);
    }

    await healthCheck(repoId, false);
  };

  const stopRepository = async (repoId: string, fromUser: boolean = false) => {
    const currentRepo = repositories.find((repo) => repo.id === repoId);
    if (fromUser && currentRepo && currentRepo.status === "PROGRESS") {
      alert("The operation is currently in progress. Please try again later.");
      return;
    }

    setRepositories((prevRepos) =>
      prevRepos.map((repo) =>
        repo.id === repoId ? { ...repo, status: "PROGRESS" } : repo
      )
    );

    try {
      const response = await fetch(`/shutdown/${repoId}`, {
        method: "GET",
      });
      if (response.ok) {
        console.log(`Repository ${repoId} stopped successfully`);
      } else {
        console.error(`Failed to stop repository ${repoId}`);
      }
    } catch (error) {
      console.error("Error stopping repository:", error);
    }

    await healthCheck(repoId, false);
  };

  const getOverallStatus = async (): Promise<string> => {
    await new Promise((resolve) => setTimeout(resolve, 500));

    const statuses = repositories.map((repo) => repo.status);
    const allGreen = statuses.every((status) => status === "GREEN");
    const allRed = statuses.every((status) => status === "RED");

    if (allGreen) {
      return "SUCCESS";
    } else if (allRed) {
      return "FAIL";
    } else if (statuses.some((status) => status === "GREEN")) {
      return "PARTIAL";
    }
    return "FAIL";
  };
  const resetRepository = async (repoId: string, fromUser: boolean = false) => {
    const currentRepo = repositories.find((repo) => repo.id === repoId);
    if (fromUser && currentRepo && currentRepo.status === "PROGRESS") {
      alert("The operation is currently in progress. Please try again later.");
      return;
    }

    setRepositories((prevRepos) =>
      prevRepos.map((repo) =>
        repo.id === repoId ? { ...repo, status: "PROGRESS" } : repo
      )
    );

    try {
      const response = await fetch(`/reset/${repoId}`, {
        method: "GET",
      });
      if (response.ok) {
        console.log(`Repository ${repoId} reset successfully`);

        const postgreOnly = [
          { id: "postgre", name: "PostgreSQL", status: "GRAY" }
        ];

        localStorage.setItem("repositories", JSON.stringify(postgreOnly));
        await fetch("/select", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ selected: "" })
          // body: JSON.stringify({ selected: null })
        });

        setRepositories(postgreOnly);
      } else {
        console.error(`Failed to reset repository ${repoId}`);
      }
    } catch (error) {
      console.error("Error reset repository:", error);
    }
    await healthCheck(repoId, false);
  };

  const statusAll = async (): Promise<string> => {
    for (const repo of repositories) {
      await healthCheck(repo.id);
    }

    await Promise.all(repositories.map((repo) => healthCheck(repo.id)));
    return getOverallStatus();
  };

  const startAll = async () => {
    for (const repo of repositories) {
      await startRepository(repo.id);
    }
  };

  const stopAll = async () => {
    for (let i = repositories.length - 1; i >= 0; i--) {
      const repo = repositories[i];
      await stopRepository(repo.id);
    }
  };

  useImperativeHandle(ref, () => ({
    getOverallStatus,
    startAll,
    stopAll,
    statusAll,
    resetRepository,
  }));

  return (
    <section className="bg-white p-6 rounded shadow mb-6">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-xl font-bold">Repositories</h2>
      </div>
      <table className="w-full text-left border-collapse">
        <thead>
          <tr className="bg-gray-100">
            <th className="p-2 w-20">Status</th>
            <th className="p-2 w-56">Name</th>
            <th className="p-2 w-96">Actions</th>
            <th className="p-2 w-56">Info</th>
          </tr>
        </thead>
        <tbody className="server-table">
          {repositories.map((repo) => (
              <tr key={repo.id} className="border-b">
                <td className="p-2 pl-6">
                  {StatusIcon(repo.status)}
                </td>
                <td className="p-2 font-bold">
                  {repo.name} <button
                      onClick={async () => {
                        try {
                          const res = await fetch(`/logs/${repo.id}.log`, {method: 'HEAD'});
                          if (res.ok) {
                            window.open(`/logs/${repo.id}.log`);
                          } else {
                            alert('Log file not found.');
                          }
                        } catch (err) {
                          alert('Log file not found.');
                        }
                      }}
                      className="text-black text-xs text-[8.5px] w-[30px] h-[25px] border border-gray-300 rounded"
                      title="By clicking this icon, you can view the logs."
                  >
                    log
                  </button>
                </td>
                <td className="p-2">
                  <div className="flex space-x-1">
                    <button
                        className="bg-green-600 text-white px-2 py-1 rounded"
                        onClick={() => startRepository(repo.id, true)}
                    >
                      Start
                    </button>
                    <button
                        className="bg-[#ED207B] text-white px-2 py-1 rounded"
                        onClick={() => stopRepository(repo.id, true)}
                    >
                      Stop
                    </button>
                    <button
                        className="bg-gray-600 text-white px-2 py-1 rounded"
                        onClick={() => healthCheck(repo.id, true)}
                    >
                      Status
                    </button>
                    {/* {repo.name === "Hyperledger Fabric" && (
                  <button
                    className="bg-[#0E76BD] text-white px-2 py-1 rounded"
                    onClick={() => resetRepository(repo.id, true)}
                  >
                    Reset
                  </button>
                  )} */}
                    {repo.name === "Hyperledger Besu" && (
                        <button
                            className="bg-[#0E76BD] text-white px-2 py-1 rounded"
                            onClick={() => props.onConfirmReset(repo.id)}
                            // onClick={() => resetRepository(repo.id, true)}
                        >
                          Reset
                        </button>
                    )}
                    {repo.name === "Ledger Service Server" && (
                        <button
                            className="bg-[#0E76BD] text-white px-2 py-1 rounded"
                            onClick={() => props.onConfirmReset(repo.id)}
                            // onClick={() => resetRepository(repo.id, true)}
                        >
                          Reset
                        </button>
                    )}
                  </div>
                </td>
                <td className="p-2"></td>
              </tr>
          ))}
        </tbody>
      </table>
    </section>


  );
});

export default Repositories;
