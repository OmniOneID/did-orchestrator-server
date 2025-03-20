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

import React, {useState, forwardRef, useImperativeHandle, useEffect, useRef} from "react";
import HelpIcon from './icons/HelpIcon';
import LogIcon from './icons/LogIcon';
import showToolTip from "./Tooltip";
import ProgressIcon from "./icons/ProgressIcon";
import StatusIcon from './StatusIcon';
import { CSSTransition } from "react-transition-group";

interface Server {
  id: string;
  name: string;
  port: number;
  status: string;
}

interface Config {
  generator: {
    easySettingModeEnabled: boolean;
    [key: string]: boolean;
  };
  [key: string]: any;
}

interface ServerProps {
  openPopupWallet: (id: string) => void;
  openPopupDid: (id: string) => void;
}

const Servers = forwardRef((props: ServerProps, ref) => {
  const { openPopupWallet, openPopupDid } = props;
  const [config, setConfig] = useState<Config | null>(null);
  const [isEasySettingEnabled, setIsEasySettingEnabled] = useState(true);

  const fetchConfigs = async (): Promise<Config | null> => {
    try {
      const response = await fetch('/configs');
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return await response.json();
    } catch (error) {
      console.error('Error fetching config:', error);
      return null;
    }
  };

  const fetchServers = (): Server[] => {
    try {
      const xhr = new XMLHttpRequest();
      xhr.open("GET", "/configs", false);
      xhr.send();

      if (xhr.status !== 200) {
        throw new Error("Failed to fetch server configurations");
      }

      const data = JSON.parse(xhr.responseText);
      
      if (data.generator && data.generator.easySettingModeEnabled !== undefined) {
        setIsEasySettingEnabled(data.generator.easySettingModeEnabled);
      }

      return Object.entries(data.services.server)
      .filter(([key, _]) => key !== "demo")
      .map(([key, value]: [string, any]) => ({
        id: key,
        name: value.name,
        port: value.port,
        status: "GRAY"
      }))
      .sort((a, b) => (a.id === "api" ? 1 : b.id === "api" ? -1 : 0));
    } catch (error) {
      console.error("Error fetching server configurations:", error);
      return [];
    }
  };

  const [servers, setServers] = useState<Server[]>(() => {
    const stored = localStorage.getItem("servers");
    if (stored) {
      try {
        return JSON.parse(stored) as Server[];
      } catch (e) {
        console.error("Error parsing servers from localStorage", e);
        return fetchServers();
      }
    }
    return fetchServers();
  });

  useEffect(() => {
    const getConfigs = async () => {
      const configData = await fetchConfigs();
      if (configData) {
        setConfig(configData);
        if (configData.generator && configData.generator.easySettingModeEnabled !== undefined) {
          setIsEasySettingEnabled(configData.generator.easySettingModeEnabled);
        }
      }
    };
    
    getConfigs();
  }, []);

  useEffect(() => {
    localStorage.setItem("servers", JSON.stringify(servers));
  }, [servers]);

  const healthCheck = async (serverId: string, serverPort: number, fromUser: boolean = false) => {
    const currentServer = servers.find((server) => server.id === serverId);
    if (fromUser && currentServer && currentServer.status === "PROGRESS") {
      alert("The operation is currently in progress. Please try again later.");
      return;
    }

    /*
    setServers((prevServers) =>
      prevServers.map((server) =>
        server.id === serverId ? { ...server, status: "PROGRESS" } : server
      )
    );
    */

    try {
      const response = await fetch(`/healthcheck/${serverPort}`, { method: "GET" });
      if (!response.ok) {
        throw new Error(`Failed to fetch health status for ${serverId}`);
      }
      const data = await response.json();
      setServers((prevServers) =>
        prevServers.map((server) =>
          server.id === serverId
            ? { ...server, status: data.status === "UP" ? "GREEN" : "RED" }
            : server
        )
      );
    } catch (error) {
      console.error("Error checking server status:", error);
      setServers((prevServers) =>
        prevServers.map((server) =>
          server.id === serverId ? { ...server, status: "RED" } : server
        )
      );
    }
  };

  const startServer = async (serverId: string, serverPort: number, fromUser: boolean = false) => {
    const currentServer = servers.find((server) => server.id === serverId);
    if (fromUser && currentServer && currentServer.status === "PROGRESS") {
      alert("The operation is currently in progress. Please try again later.");
      return;
    }

    setServers((prevServers) =>
      prevServers.map((server) =>
        server.id === serverId ? { ...server, status: "PROGRESS" } : server
      )
    );

    try {
      const response = await fetch(`/startup/${serverPort}`, { method: "GET" });
      if (response.ok) {
        console.log(`Server ${serverId} started successfully`);
        await waitForServerHealth(serverId, serverPort, "start"); 
      } else {
        console.error(`Failed to start server ${serverId}`);
      }
    } catch (error) {
      console.error("Error starting server:", error);
    }
  };

  const stopServer = async (serverId: string, serverPort: number, fromUser: boolean = false) => {
    const currentServer = servers.find((server) => server.id === serverId);
    if (fromUser && currentServer && currentServer.status === "PROGRESS") {
      alert("The operation is currently in progress. Please try again later.");
      return;
    }

    setServers((prevServers) =>
      prevServers.map((server) =>
        server.id === serverId ? { ...server, status: "PROGRESS" } : server
      )
    );

    try {
      const response = await fetch(`/shutdown/${serverPort}`, { method: "GET" });
      if (response.ok) {
        console.log(`Server ${serverId} stopped successfully`);
        await waitForServerHealth(serverId, serverPort, "stop"); 
      } else {
        console.error(`Failed to stop server ${serverId}`);
      }
    } catch (error) {
      console.error("Error stopping server:", error);
    }
  }

   const waitForServerHealth = async (serverId: string, serverPort: number, mode: string, maxRetries = 10, interval = 2000) => {
    for (let i = 0; i < maxRetries; i++) {
        await new Promise((resolve) => setTimeout(resolve, interval)); 
        try {
            const response = await fetch(`/healthcheck/${serverPort}`, { method: "GET" });
            if (response.ok) {
                const data = await response.json();
                if (mode == "start") {
                  if (data.status === "UP") {
                      setServers((prevServers) =>
                          prevServers.map((server) =>
                              server.id === serverId ? { ...server, status: "GREEN" } : server
                          )
                      );
                      console.log(`Server ${serverId} is now UP`);
                      return;
                  }
                }
                if (mode == "stop") {
                  if (data.status === "DOWN") {
                      setServers((prevServers) =>
                          prevServers.map((server) =>
                              server.id === serverId ? { ...server, status: "RED" } : server
                          )
                      );
                      console.log(`Server ${serverId} is now DOWN`);
                      return;
                  }
                }
            }
        } catch (error) {
            console.error("Error checking health status:", error);
        }
    }

    console.log(`Server ${serverId} is still DOWN after retries`);
    setServers((prevServers) =>
        prevServers.map((server) =>
            server.id === serverId ? { ...server, status: "RED" } : server
        )
    );
  };

  const getOverallStatus = async (): Promise<string> => {
    await new Promise((resolve) => setTimeout(resolve, 500));

    const statuses = servers.map((server) => server.status);
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

  const statusAll = async (): Promise<string> => {
    for (const server of servers) {
      await healthCheck(server.id, server.port);
    }

    await Promise.all(servers.map((server) => healthCheck(server.id, server.port)));
    return getOverallStatus();
  };

  const startAll = async () => {
    for (const server of servers) {
      await startServer(server.id, server.port);
    }
  };

  const stopAll = async () => {
    for (let i = servers.length - 1; i >= 0; i--) {
      const server = servers[i];
      await stopServer(server.id, server.port);
    }
  };

  useImperativeHandle(ref, () => ({
    getOverallStatus,
    startAll,
    stopAll,
    statusAll,
  }));

  return (
    <section className="bg-white p-6 rounded shadow mb-6">
      <h2 className="text-xl font-bold mb-4">Servers</h2>
      <table className="w-full text-left border-collapse">
        <thead>
          <tr className="bg-gray-100">
            <th className="p-2 w-20">Status</th>
            <th className="p-2 w-56">Name</th>
            <th className="p-2 w-56">Actions</th>
            <th className="p-2 w-48">Info</th>
            <th className="p-2 w-48">
              Generators
              <CSSTransition
                      in={!isEasySettingEnabled}
                      timeout={300}
                      classNames="fade"
                      unmountOnExit
              >
                <span>
                <button
                  onClick={(e) =>
                    showToolTip(
                      "generate Wallet and DID Document individually.<br>Notice:<br>- For each entity, you need to create the Wallet first and then the DID Document.<br>- Please create the Wallet and DID Document for TAS first, and then proceed with the processes for the remaining entities.",
                      e
                    )
                  }
                  className="text-gray-500 hover:text-gray-700"
                >
                <HelpIcon width="1em" height="1em" />
                </button>
                </span>
              </CSSTransition>
            </th>
          </tr>
        </thead>
        <tbody>
          {servers.map((server) => (
            <tr key={server.id} className="border-b">
              <td className="p-2 pl-6 all">
                {StatusIcon(server.status)}
              </td>
              <td className="p-2 font-bold">
                {server.name} ({server.port}) <button onClick={() => window.open(`/logs/server_${server.port}.log`)} className="text-black text-xs text-[8.5px] w-[30px] h-[25px] border border-gray-300 rounded" title='By clicking this icon, you can view the logs.'>log</button>
              </td>
              <td className="p-2">
                <div className="flex space-x-1">
                  <button
                    className="bg-green-600 text-white px-2 py-1 rounded"
                    onClick={() => startServer(server.id, server.port, true)}
                  >
                    Start
                  </button>
                  <button
                    className="bg-[#ED207B] text-white px-2 py-1 rounded"
                    onClick={() => stopServer(server.id, server.port, true)}
                  >
                    Stop
                  </button>
                  <button 
                    className="bg-gray-600 text-white px-2 py-1 rounded"
                    onClick={() => healthCheck(server.id, server.port, true)}
                  >
                    Status
                  </button>
                </div>
              </td>
              <td className="p-2">
                <div className="flex space-x-1">
                  <button 
                  className="bg-gray-600 text-white px-2 py-1 rounded"
                  onClick={() => window.open(`http://localhost:${server.port}`)}
                  >
                    Settings
                  </button>
                  <button 
                  className="bg-gray-600 text-white px-2 py-1 rounded"
                  onClick={() => window.open(`http://localhost:${server.port}/swagger-ui/index.html`)}
                  >
                    Swagger
                  </button>
                </div>
              </td>
              {server.id !== "api" && (
                <td className="p-2">
                    <CSSTransition
                      in={!isEasySettingEnabled}
                      timeout={300}
                      classNames="fade"
                      unmountOnExit
                    >
                  <div className="flex space-x-1">
                    <button
                      className="bg-orange-500 text-white px-2 py-1 rounded"
                      onClick={() => openPopupWallet(server.id)}
                    >
                      Wallet
                    </button>
                    <button
                      className="bg-orange-500 text-white px-2 py-1 rounded"
                      onClick={() => openPopupDid(server.id)}
                    >
                      DID Document
                    </button>
                  </div>
                  </CSSTransition>
                </td>
              )}
              {server.id === "api" && <td></td>}
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
});

export default Servers;