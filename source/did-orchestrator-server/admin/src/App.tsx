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

import React, { useState, useRef, useEffect } from 'react';
import Servers from "./Servers";
import Repositories from "./Repositories";
import Demo from "./Demo";
import HelpIcon from './icons/HelpIcon';
import showToolTip from "./Tooltip";
import ProgressIcon from './icons/ProgressIcon';
import ProgressOverlay from './ProgressOverlay';

const generateRandomDid = (): string => {
  const randomHex = [...Array(25)]
    .map(() => Math.floor(Math.random() * 15).toString(15))
    .join('');
  return `did:omn:0x${randomHex}`;
};

const App: React.FC = () => {
  const [isSaving, setIsSaving] = useState(false);
  const [popupDid, setPopupDid] = useState<string | null>(null);
  const [popupWallet, setPopupWallet] = useState<string | null>(null);
  const [popupGenAll, setPopupGenAll] = useState(false);

  const [status, setStatus] = useState<string>(() => {
    const stored = localStorage.getItem("allStatus");
    return stored ? stored : "⚪";
  });

  useEffect(() => {
    localStorage.setItem("allStatus", status);
  }, [status]);

  const hasMountedRef = useRef(false);

  const sectionRef = (node: HTMLElement | null) => {
    if (node && !hasMountedRef.current) {
      hasMountedRef.current = true;
      if(status != "⚪") statusAll();
    }
  };

  const openPopupDid = (id: string) => setPopupDid(id);
  const closePopupDid = () => setPopupDid(null);
  const openPopupWallet = (id: string) => setPopupWallet(id);
  const closePopupWallet = () => setPopupWallet(null);
  const openGenerateAll = () => setPopupGenAll(true);
  const closeGenerateAll = () => setPopupGenAll(false);

  const genAllSubmitGenAllPasswordRef = useRef<HTMLInputElement>(null);
  const genAllSubmitGenAllConfirmPasswordRef = useRef<HTMLInputElement>(null);

  const handleGenAllSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const formData = new FormData(e.currentTarget);
    const password = formData.get("genAllPassword") as string;
    const confirmPassword = formData.get("genAllConfirmPassword") as string;
    if (password == "") {
      alert("Please enter your password.");
      genAllSubmitGenAllPasswordRef.current?.focus();
      return;
    }
    if (password !== confirmPassword || confirmPassword == "") {
      alert("Passwords do not match!");
      genAllSubmitGenAllConfirmPasswordRef.current?.focus();
      return;
    }
    
    try {
      setIsSaving(true);

      var apiResponse;
      const serversData = localStorage.getItem("servers");
      if (serversData) {
      /*
        try {
          const servers = JSON.parse(serversData);
          if (Array.isArray(servers)) {
            for (let i = 0; i < servers.length; i++) {
              if (servers[i].id === "api") {
                continue;
              }

              var serverId = servers[i].id;

              var filename = serverId;
              var keyIds = ["assert", "auth", "keyagree"];
              if(serverId == "tas") {
                keyIds = ["assert", "auth", "keyagree", "invoke"];
              }
              var type = "ENTITY";
              if(serverId == "tas") {
                type = "TAS";
              }

              apiResponse = await fetch("/create/wallet", {
                method: "POST",
                headers: {
                  "Content-Type": "application/json; charset=UTF-8",
                },
                body: JSON.stringify({ filename : filename, password }),
              });

              if (!apiResponse.ok) {
                const errorData = await apiResponse.json();
                alert(`Generation All creation failed: ${errorData.message || "Unknown error."}`);
                return;
              }

              apiResponse = await fetch("/create/keys", {
                method: "POST",
                headers: {
                  "Content-Type": "application/json; charset=UTF-8",
                },
                body: JSON.stringify({ filename, password, keyIds: keyIds }),
              });

              if (!apiResponse.ok) {
                const errorData = await apiResponse.json();
                alert(`Generation All creation failed: ${errorData.message || "Unknown error."}`);
                return;
              }

              apiResponse = await fetch("/create/diddoc", {
                method: "POST",
                headers: {
                  "Content-Type": "application/json; charset=UTF-8",
                },
                body: JSON.stringify({ filename, password, did : "did:omn:" + filename, controller : "did:omn:tas", type : type }),
              });

              if (!apiResponse.ok) {
                const errorData = await apiResponse.json();
                alert(`Generation All creation failed: ${errorData.message || "Unknown error."}`);
                return;
              }
            }
            alert(`Generation All created successfully!`);
            closeGenerateAll();
          } else {
            alert(`Generation All creation failed`);
          }
        } catch (error) {
          alert(`Generation All creation failed`);
        } finally {
          setIsSaving(false);
        }
      */
        apiResponse = await fetch("/create/all", {
          method: "POST",
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
          },
          body: JSON.stringify({ password }),
        });

        if (!apiResponse.ok) {
          const errorData = await apiResponse.json();
          alert(`Generation All creation failed: ${errorData.message || "Unknown error."}`);
          return;
        }
        alert(`Generation All created successfully!`);
        closeGenerateAll();
      } else {
        alert(`Generation All creation failed - No servers data found in localStorage.`);
      }
    } catch (error) {
      console.error("Error creating wallet:", error);
      alert("An error occurred while creating the wallet.");
    } finally {
      setIsSaving(false);
    }
  };

  const walletSubmitDidRefWalletRef = useRef<HTMLInputElement>(null);
  const walletSubmitDidRefPasswordRef = useRef<HTMLInputElement>(null);
  const walletSubmitDidRefConfirmPasswordRef = useRef<HTMLInputElement>(null);

  const handleWalletSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);

    const filename = formData.get("walletName") as string;
    const password = formData.get("walletPassword") as string;
    const confirmPassword = formData.get("walletConfirmPassword") as string;

    if (filename == "") {
      alert("Please enter your wallet name.");
      walletSubmitDidRefWalletRef.current?.focus();
      return;
    }
    if (password == "") {
      alert("Please enter your password.");
      walletSubmitDidRefPasswordRef.current?.focus();
      return;
    }
    if (password !== confirmPassword || confirmPassword == "") {
      alert("Passwords do not match!");
      walletSubmitDidRefConfirmPasswordRef.current?.focus();
      return;
    }

    setIsSaving(true);

    var keyIds = ["assert", "auth", "keyagree"];
    if (filename == "tas") {
      keyIds = ["assert", "auth", "keyagree", "invoke"];
    }

    try {
      const walletResponse = await fetch("/create/wallet", {
        method: "POST",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: JSON.stringify({ filename, password }),
      });
  
      if (!walletResponse.ok) {
        const errorData = await walletResponse.json();
        alert(`Wallet creation failed: ${errorData.message || "Unknown error."}`);
        return;
      }
  
      const keysResponse = await fetch("/create/keys", {
        method: "POST",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: JSON.stringify({ filename, password, keyIds: keyIds}),
      });
  
      if (!keysResponse.ok) {
        const errorData = await keysResponse.json();
        alert(`Keys creation failed: ${errorData.message || "Unknown error."}`);
        return;
      }
  
      alert("Wallet created successfully!");
      closePopupWallet();
    } catch (error) {
      console.error("Error creating wallet:", error);
      alert("An error occurred while creating the wallet.");
    } finally {
      setIsSaving(false);
    }
  };

  const didSubmitDidRef = useRef<HTMLInputElement>(null);
  const didSubmitDidRefWalletRef = useRef<HTMLInputElement>(null);
  const didSubmitDidRefPasswordRef = useRef<HTMLInputElement>(null);
  const didSubmitDidRefConfirmPasswordRef = useRef<HTMLInputElement>(null);

  const handleDidSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);

    const did = formData.get("did") as string;
    const walletName = formData.get("walletName") as string;
    const password = formData.get("didPassword") as string;
    const confirmPassword = formData.get("didConfirmPassword") as string;

    if (walletName == "tas") {
      localStorage.setItem("didType", "TAS");
    } else {
      localStorage.setItem("didType", "ENTITY");
    }

    if (did == "") {
      alert("Please enter your DID.");
      didSubmitDidRef.current?.focus();
      return;
    }
    const didRegex = /^did:[a-zA-Z0-9]+:[a-zA-Z0-9]+$/;
    if (!didRegex.test(did)) {
      alert("Please follow the DID format.");
      didSubmitDidRef.current?.focus();
      return;
    }
    if (walletName == "") {
      alert("Please enter your wallet name.");
      didSubmitDidRefWalletRef.current?.focus();
      return;
    }
    if (password == "") {
      alert("Please enter your password.");
      didSubmitDidRefPasswordRef.current?.focus();
      return;
    }
    if (password !== confirmPassword || confirmPassword == "") {
      alert("Passwords do not match!");
      didSubmitDidRefConfirmPasswordRef.current?.focus();
      return;
    }

    var controller = localStorage.getItem("didController") || "did:omn:tas";
    const type = localStorage.getItem("didType");
    if (type == "TAS") {
      controller = did;
    }

    const filename = walletName;

    setIsSaving(true);

    try {
      const walletResponse = await fetch("/create/diddoc", {
        method: "POST",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: JSON.stringify({ filename, password, did, controller, type }),
      });
  
      if (!walletResponse.ok) {
        const errorData = await walletResponse.json();
        alert(`Wallet creation failed: ${errorData.message || "Unknown error."}`);
        return;
      }

      if (type == "TAS") {
        localStorage.setItem("didController", did);
      }

      alert("DID Document created successfully!");
      closePopupDid();
    } catch (error) {
      console.error("Error creating wallet:", error);
      alert("An error occurred while creating the DID Document.");
    } finally {
      setIsSaving(false);
    }
  };

  const repositoriesRef = useRef<{
    startAll: () => Promise<void>;
    stopAll: () => Promise<void>;
    getOverallStatus: () => string; 
    statusAll: () => Promise<string>;
  }>(null);

  const serversRef = useRef<{
    startAll: () => Promise<void>;
    stopAll: () => Promise<void>;
    getOverallStatus: () => string;
    statusAll: () => Promise<string>;
  }>(null);

  const demoRef = useRef<{
    shouldRenderDemoActionsAndInfo: () => boolean
    startDemo: () => Promise<string>;
    stopDemo: () => Promise<string>;
    healthCheckDemo: () => Promise<string>;
  } | null>(null);

  const startAll = async () => {
    if (status === "PROGRESS") {
      alert("The operation is currently in progress. Please try again later.");
      return;
    }

    setStatus("PROGRESS");
    if (repositoriesRef.current) {
      await repositoriesRef.current.startAll();
    }
    if (serversRef.current) {
      await serversRef.current.startAll();
    }
    if (demoRef.current) {
      await demoRef.current.startDemo();
    }

    statusAll();
  };

  const stopAll = async () => {
    if (status === "PROGRESS") {
      alert("The operation is currently in progress. Please try again later.");
      return;
    }

    setStatus("PROGRESS");
    if (serversRef.current) {
      await serversRef.current.stopAll();
    }
    if (repositoriesRef.current) {
      await repositoriesRef.current.stopAll();
    }
    if (demoRef.current) {
      await demoRef.current.stopDemo();
    }

    statusAll();
  };

  const statusAll = async () => {
    setStatus("PROGRESS");

    if (serversRef.current) {
      await serversRef.current.statusAll();
    }
    if (repositoriesRef.current) {
      await repositoriesRef.current.statusAll();
    }
    if (demoRef.current) {
      await demoRef.current.healthCheckDemo();
    }

    const repoStatus = repositoriesRef.current ? await repositoriesRef.current.getOverallStatus() : "FAIL";
    const serverStatus = serversRef.current ? await serversRef.current.getOverallStatus() : "FAIL";

    console.log("repoStatus : " + repoStatus);
    console.log("serverStatus : " + serverStatus);

    if (repoStatus === "SUCCESS" && serverStatus === "SUCCESS") {
      setStatus("🟢");
    } else if (repoStatus === "FAIL" && serverStatus === "FAIL") {
      setStatus("🔴");
    } else {
      setStatus("🟡");
    }

    if (demoRef.current) {
      await demoRef.current.shouldRenderDemoActionsAndInfo();
    }
  };

  return (
    <div className="bg-gray-100">
      <div className="flex h-screen">
        {/* Sidebar */}
        <aside className="w-64 bg-gray-900 text-white flex flex-col border-r border-gray-300 h-[1250px]">
          <div className="p-6 text-lg font-bold">OmniOne OpenDID Orchestrator</div>
          <nav className="flex-1">
            <a href="/" className="block py-3 px-6 bg-orange-500">
              Dashboard
            </a>
            <a href="/conf" className="block py-3 px-6 bg-gray-800">
              Configuration
            </a>
          </nav>
          <div className="p-6 text-sm text-gray-400 flex-grow"></div>
        </aside>

        {/* Main Content */}
        <main ref={sectionRef} className="flex-1 p-6 bg-gray-100 h-[1250px]">
          {/* Top Header */}
          <header className="flex justify-between items-center mb-6">
            <h1 className="text-2xl font-bold">Dashboard</h1>
            <button onClick={() => window.open('help')} className="text-gray-500 hover:text-gray-700">
              <HelpIcon width="1.5em" height="1.5em" />
            </button>
          </header>

          {/* QuickStart Table */}
          <section className="bg-white p-6 rounded shadow mb-6">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-bold">Quick Start</h2>
            </div>
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-gray-200">
                  <th className="p-2 w-20">Status</th>
                  <th className="p-2 w-56">Name</th>
                  <th className="p-2 w-56">
                    Actions
                    <button
                      onClick={(e) =>
                        showToolTip(
                          "This supports starting and stopping all entities sequentially.<br/> - Status All: If any entity's status becomes abnormal due to a browser refresh or similar event,<br> clicking this button will check and normalize the status of all entities.",
                          e
                        )
                      }
                      className="text-gray-500 hover:text-gray-700"
                    >
                      <HelpIcon width="1em" height="1em" />
                    </button>
                  </th>
                  <th className="p-2 w-48">Info</th>
                  <th className="p-2 w-48">
                    Generators
                    <button
                      onClick={(e) =>
                        showToolTip(
                          "Automatically generate Wallet and DID Document in bulk.<br/> If you prefer to create them individually, please use the Generators in the Servers section below.",
                          e
                        )
                      }
                      className="text-gray-500 hover:text-gray-700"
                    >
                      <HelpIcon width="1em" height="1em" />
                    </button>
                  </th>
                </tr>
              </thead>
              <tbody className="server-table">
                <tr className="border-b">
                  <td className="p-2 pl-6 all">
                    {status === "PROGRESS" ? <ProgressIcon /> : status}
                  </td>
                  <td className="p-2 font-bold">All Entities</td>
                  <td className="p-2">
                    <div className="flex space-x-1">
                      <button
                        className="bg-green-600 text-white px-3 py-1 rounded"
                        onClick={startAll}
                      >
                        Start All
                      </button>
                      <button
                        className="bg-red-600 text-white px-3 py-1 rounded"
                        onClick={stopAll}
                      >
                        Stop All
                      </button>
                      <button
                        className="bg-gray-600 text-white px-3 py-1 rounded"
                        onClick={statusAll}
                      >
                        Status All
                      </button>
                    </div>
                  </td>
                  <td className="p-2"></td>
                  <td className="p-2">
                    <button
                      className="bg-orange-500 text-white px-3 py-1 rounded"
                      onClick={openGenerateAll}
                    >
                      Generate All
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </section>

          {/* Repositories Table */}
          <Repositories ref={repositoriesRef} />

          {/* Servers Table */}
          <Servers
            ref={serversRef} 
            openPopupWallet={openPopupWallet}
            openPopupDid={openPopupDid}
          />

          <Demo ref={demoRef} />
        </main>
      </div>

      {/* Gen All Popup */}
      {popupGenAll && (
        <div id="popup-overlay-genall" className="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center">
          <div className="bg-white w-96 p-6 rounded-lg shadow-lg">
            <h2 className="text-lg font-bold border-b pb-2 mb-4">Wallet & Document All Generator</h2>
            <form onSubmit={handleGenAllSubmit}>
              <div className="mb-4">
                <label className="block text-sm font-bold text-gray-700">Password</label>
                <input type="password" name="genAllPassword" ref={genAllSubmitGenAllPasswordRef} className="w-full border p-2 rounded" maxLength={10} autoFocus />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-bold text-gray-700">Confirm Password</label>
                <input type="password" name="genAllConfirmPassword" ref={genAllSubmitGenAllConfirmPasswordRef} className="w-full border p-2 rounded" maxLength={10} />
              </div>
              <div className="flex justify-end space-x-2">
                <button type="button" onClick={closeGenerateAll} className="px-4 py-2 border rounded text-gray-700">
                  Cancel
                </button>
                <button type="submit" className="px-4 py-2 bg-orange-500 text-white rounded">
                  Generate
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* DID Document Generator Popup */}
      {popupDid && (
        <div id="popup-overlay-did" className="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center">
          <div className="bg-white w-96 p-6 rounded-lg shadow-lg">
            <h2 className="text-lg font-bold border-b pb-2 mb-4">DID Document Generator</h2>
            <form onSubmit={handleDidSubmit}>
              <div className="mb-4">
                <label className="block text-sm font-bold text-gray-700">DID</label>
                <input type="text" name="did" ref={didSubmitDidRef} className="w-full border p-2 rounded" defaultValue={generateRandomDid()} maxLength={35} />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-bold text-gray-700">Wallet Name</label>
                <input type="text" name="walletName" ref={didSubmitDidRefWalletRef} className="w-full border p-2 rounded" defaultValue={popupDid} maxLength={10} />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-bold text-gray-700">Password</label>
                <input type="password" name="didPassword" ref={didSubmitDidRefPasswordRef} className="w-full border p-2 rounded" maxLength={10} autoFocus />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-bold text-gray-700">Confirm Password</label>
                <input type="password" name="didConfirmPassword" ref={didSubmitDidRefConfirmPasswordRef} className="w-full border p-2 rounded" maxLength={10} />
              </div>
              <div className="flex justify-end space-x-2">
                <button type="button" onClick={closePopupDid} className="px-4 py-2 border rounded text-gray-700">
                  Cancel
                </button>
                <button type="submit" className="px-4 py-2 bg-orange-500 text-white rounded">
                  Generate
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Wallet Generator Popup */}
      {popupWallet && (
        <div id="popup-overlay-wallet" className="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center">
          <div className="bg-white w-96 p-6 rounded-lg shadow-lg">
            <h2 className="text-lg font-bold border-b pb-2 mb-4">Wallet Generator</h2>
            <form onSubmit={handleWalletSubmit}>
              <div className="mb-4">
                <label className="block text-sm font-bold text-gray-700">Wallet Name</label>
                <input type="text" name="walletName" ref={walletSubmitDidRefWalletRef} className="w-full border p-2 rounded" defaultValue={popupWallet} />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-bold text-gray-700">Password</label>
                <input type="password" name="walletPassword" ref={walletSubmitDidRefPasswordRef} className="w-full border p-2 rounded" autoFocus />
              </div>
              <div className="mb-4">
                <label className="block text-sm font-bold text-gray-700">Confirm Password</label>
                <input type="password" name="walletConfirmPassword" ref={walletSubmitDidRefConfirmPasswordRef} className="w-full border p-2 rounded" />
              </div>
              <div className="flex justify-end space-x-2">
                <button type="button" onClick={closePopupWallet} className="px-4 py-2 border rounded text-gray-700">
                  Cancel
                </button>
                <button type="submit" className="px-4 py-2 bg-orange-500 text-white rounded">
                  Generate
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Progress Overlay Modal */}
      {isSaving && <ProgressOverlay />}
    </div>
  );
};

export default App;
