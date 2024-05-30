import React, { useState, useCallback, useEffect } from "react";
import Account from "./Account";
import { useBonsaiPayClaimedEvent, useBonsaiPayBalanceOf } from "../generated";
import { sha256 } from "@noble/hashes/sha256";
import { toHex } from "viem";

interface ProveProps {
  disabled: boolean;
  email: string | null;
}

const Prove: React.FC<ProveProps> = ({ disabled, email }) => {
  const [isLoading, setIsLoading] = useState(false);
  const [isClaimed, setIsClaimed] = useState(false);
  const [isNonZeroBalance, setIsNonZeroBalance] = useState(false);

  useBonsaiPayClaimedEvent({
    listener: () => {
      setIsClaimed(true);
    },
  });

  const { data: balance } = useBonsaiPayBalanceOf({
    args: [toHex(sha256(email ?? ""))],
  });

  useEffect(() => { 
    setIsNonZeroBalance(balance !== 0n);
  }, [balance]);


  const { VITE_API_HOST } = import.meta.env;

  const handleClick = useCallback(async () => {
    setIsLoading(true);

    const jwtCookie = document.cookie
      .split("; ")
      .find((row) => row.startsWith("jwt="));
    const jwt = jwtCookie?.split("=")[1];

    if (!jwt) {
      console.error("JWT not found");
      setIsLoading(false);
      return;
    }
    console.log(jwt);

    try {
      const response = await fetch(`${VITE_API_HOST}/auth`, {
        method: "GET",
        headers: {
          "X-Auth-Token": jwt,
          "X-To": "0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8"
        },
      });

      if (response.ok) {
        await response.body;
      } else {
        throw new Error("Response not OK");
      }
    } catch (error) {
      console.error("Error fetching data:", error);
    } finally {
      setIsLoading(false);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <>
      <Account email={email} disabled={disabled} hideClaim={true} />
      <button onClick={handleClick} disabled={isLoading || disabled || isClaimed }>
        {isClaimed ? "Claimed" : isLoading ? "Proving..." : "Prove with Bonsai™"}
      </button>
      {isLoading ? <p>This will take a few moments...</p> : <p></p>} 
    </>
  );
};

export default Prove;