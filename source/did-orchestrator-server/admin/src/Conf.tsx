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

import React, { useState, useEffect } from 'react';
import HelpIcon from './icons/HelpIcon';
import showToolTip from "./Tooltip";
import ProgressOverlay from './ProgressOverlay';

interface Config {
  blockchain: { [key: string]: string };
  database: { [key: string]: string };
  services: {
    server: {
      [key: string]: {
        name: string;
        port: number;
        file: string;
      };
    };
    [key: string]: any;
  };
}

const Conf: React.FC = () => {
  const [config, setConfig] = useState<Config | null>(null);
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    const fetchConfig = async () => {
      try {
        const response = await fetch('/configs');
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const configData = await response.json();
        setConfig(configData);
      } catch (error) {
        console.error('Error fetching config:', error);
      }
    };
  
    fetchConfig();
  }, []);

  const handleConfigChange = (
    section: 'blockchain' | 'database',
    key: string,
    e: React.ChangeEvent<HTMLInputElement>
  ) => {
    if (!config) return;
    setConfig({
      ...config,
      [section]: {
        ...config[section],
        [key]: e.target.value,
      },
    });
  };

  const handleServicesPathChange = (
    key: string,
    e: React.ChangeEvent<HTMLInputElement>
  ) => {
    if (!config) return;
    setConfig({
      ...config,
      services: {
        ...config.services,
        [key]: e.target.value,
      },
    });
  };

  const handleServerChange = (
    serverKey: string,
    field: 'name' | 'port' | 'file',
    e: React.ChangeEvent<HTMLInputElement>
  ) => {
    if (!config) return;
    setConfig({
      ...config,
      services: {
        ...config.services,
        server: {
          ...config.services.server,
          [serverKey]: {
            ...config.services.server[serverKey],
            [field]: field === 'port' ? Number(e.target.value) : e.target.value,
          },
        },
      },
    });
  };

  const handleSave = async () => {
    if (!config) return;
    setIsSaving(true);
    try {
      const updateResponse = await fetch('/configs', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(config),
      });
      if (!updateResponse.ok) {
        throw new Error(`HTTP error updating config! status: ${updateResponse.status}`);
      }
      console.log('Config saved successfully!');

      await new Promise(resolve => setTimeout(resolve, 1000));

      const refreshResponse = await fetch('/actuator/refresh', {
        method: 'POST',
      });
      if (!refreshResponse.ok) {
        throw new Error(`HTTP error refreshing actuator! status: ${refreshResponse.status}`);
      }
      console.log('Actuator refreshed successfully!');

      localStorage.removeItem("servers");

      alert('Config saved successfully!');
      window.location.reload();
    } catch (error) {
      console.error('Error updating config:', error);
    } finally {
      setIsSaving(false);
    }
  };

  if (!config) {
    return (
      <ProgressOverlay />
    );
  }

  const servicePathKeys = Object.keys(config.services).filter(
    key => key !== 'server'
  );

  return (
    <>
      <div className="bg-gray-100 min-h-screen">
        <div className="flex">
          {/* Sidebar */}
          <aside className="w-64 bg-gray-900 text-white flex flex-col border-r border-gray-300 min-h-screen">
            <div className="p-6 text-lg font-bold">OmniOne OpenDID Orchestrator</div>
            <nav className="flex-1">
              <a href="/" className="block py-3 px-6 bg-gray-800">
                Dashboard
              </a>
              <a href="/conf" className="block py-3 px-6 bg-orange-500">
                Configuration
              </a>
            </nav>
            <div className="p-6 text-sm text-gray-400"></div>
          </aside>

          {/* Main Content */}
          <main className="flex-1 p-6">
            <header className="flex justify-between items-center mb-6">
              <h1 className="text-2xl font-bold">Configuration</h1>
            </header>

            <section className="bg-white p-6 rounded shadow mb-6">
              <h2 className="text-xl font-bold mb-4">Repositories</h2>
              {/* Blockchain Section */}
              <div className="mb-6">
                <h3 className="text-lg font-bold mb-4">
                  Blockchain
                  <button
                    onClick={(e) =>
                      showToolTip(
                        "The following settings are parameters applied when running Hyperledger Fabric. <br>Their meanings are as follows: <br> - Channel: The name of the channel created when running Fabric.<br> - ChaincodeName: The name of the chaincode deployed when running Fabric.",
                        e
                      )
                    }
                    className="text-gray-500 hover:text-gray-700 ml-1"
                  >
                    <HelpIcon width="0.9em" height="0.9em" />
                  </button>
                </h3>
                <table className="min-w-full">
                  <thead>
                    <tr className="bg-gray-200">
                      <th className="p-2 text-left w-48">Key</th>
                      <th className="p-2 text-left w-96">Value</th>
                    </tr>
                  </thead>
                  <tbody>
                    {Object.entries(config.blockchain).map(([key, value]) => (
                      <tr key={key} className="border-b">
                        <td className="p-2 font-bold capitalize">{key}</td>
                        <td className="p-2">
                          <input
                            type="text"
                            className="border rounded p-2 w-full"
                            value={value}
                            onChange={(e) => handleConfigChange('blockchain', key, e)}
                            maxLength={30}
                          />
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* Database Section */}
              <div className="mb-6">
                <h3 className="text-lg font-bold mb-4">
                  Database
                  <button
                      onClick={(e) =>
                          showToolTip(
                              "The following settings are parameters applied when running PostresSQL. <br>Their meanings are as follows: <br>- Port: The port on which the database will run.<br>- User: The master user ID for the database.<br>- Password: The master user password for the database.<br>- Db: The name of the default database.",
                              e
                          )
                      }
                      className="text-gray-500 hover:text-gray-700 ml-1">
                    <HelpIcon width="0.9em" height="0.9em" />
                  </button>
                </h3>
                <table className="min-w-full">
                  <thead>
                    <tr className="bg-gray-200">
                      <th className="p-2 text-left w-48">Key</th>
                      <th className="p-2 text-left w-96">Value</th>
                    </tr>
                  </thead>
                  <tbody>
                    {Object.entries(config.database).map(([key, value]) => (
                      <tr key={key} className="border-b">
                        <td className="p-2 font-bold capitalize">{key}</td>
                        <td className="p-2">
                          <input
                            type="text"
                            className="border rounded p-2 w-full"
                            value={value}
                            onChange={(e) => handleConfigChange('database', key, e)}
                            maxLength={30}
                          />
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </section>

            {/* Services Section */}
            <section className="bg-white p-6 rounded shadow mb-6">
              <h2 className="text-xl font-bold mb-4">Servers</h2>
              {/* Server Configuration */}
              <div className="mb-6">
                <h3 className="text-lg font-bold mb-2">
                  Server
                  <button
                      onClick={(e) =>
                          showToolTip(
                              "The following settings are parameters applied when finding Servers. <br>Their meanings are as follows: <br>- Service: Unique ID of the service.<br>- Name: Name of the service.<br>- Port: Port used by the service.<br>- File: Name of the JAR file.",
                              e
                          )
                      }
                      className="text-gray-500 hover:text-gray-700 ml-1">
                    <HelpIcon width="0.9em" height="0.9em" />
                  </button>
                </h3>
                <table className="min-w-full">
                  <thead>
                    <tr className="bg-gray-200">
                      <th className="p-2 text-left w-48">Service</th>
                      <th className="p-2 text-left w-48">Name</th>
                      <th className="p-2 text-left w-48">Port</th>
                      <th className="p-2 text-left w-48">File</th>
                    </tr>
                  </thead>
                  <tbody>
                    {Object.entries(config.services.server).map(([key, service]) => (
                      <tr key={key} className="border-b">
                        <td className="p-2 font-bold capitalize">{key}</td>
                        <td className="p-2">
                          <input
                            type="text"
                            className="border rounded p-2 w-full"
                            value={service.name}
                            onChange={(e) => handleServerChange(key, 'name', e)}
                            maxLength={30}
                          />
                        </td>
                        <td className="p-2">
                          <input
                            type="text"
                            className="border rounded p-2 w-full"
                            value={service.port}
                            onChange={(e) => handleServerChange(key, 'port', e)}
                            maxLength={30}
                          />
                        </td>
                        <td className="p-2">
                          <input
                            type="text"
                            className="border rounded p-2 w-full"
                            value={service.file}
                            onChange={(e) => handleServerChange(key, 'file', e)}
                            maxLength={50}
                          />
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* Service Paths Configuration */}
              <div>
                <h3 className="text-lg font-bold mb-2">
                  Service Paths
                  <button
                      className="text-gray-500 hover:text-gray-700 ml-1"
                      onClick={(e) =>
                          showToolTip(
                              "The following settings are parameters of service paths. <br>Their meanings are as follows: <br>- jarPath: JAR file path<br>- walletPath: Wallet file path<br>- didDocPath: DID Document file path<br>- cliToolPath: CLI Tool path<br>- logPath: Log file path<br>",
                              e
                          )
                      }>
                    <HelpIcon width="0.9em" height="0.9em" />
                  </button>
                </h3>
                <table className="min-w-full">
                  <thead>
                    <tr className="bg-gray-200">
                      <th className="p-2 text-left w-48">Key</th>
                      <th className="p-2 text-left w-96">Value</th>
                    </tr>
                  </thead>
                  <tbody>
                    {servicePathKeys.map((key) => (
                      <tr key={key} className="border-b">
                        <td className="p-2 font-bold capitalize">{key}</td>
                        <td className="p-2">
                          <input
                            type="text"
                            className="border rounded p-2 w-full"
                            value={config.services[key]}
                            onChange={(e) => handleServicesPathChange(key, e)}
                            maxLength={30}
                          />
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </section>

            {/* Save Button */}
            <div className="flex justify-end space-x-2 mt-6">
              <button
                className="bg-orange-500 text-white px-4 py-2 rounded"
                onClick={handleSave}
              >
                Save
              </button>
            </div>
          </main>
        </div>
      </div>

      {/* Progress Overlay Modal */}
      {isSaving && <ProgressOverlay />}
    </>
  );
};

export default Conf;
