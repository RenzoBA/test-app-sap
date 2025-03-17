import Link from "next/link";
import { getUserByIdentityDocNum } from "../lib/utils";

const page = async () => {
  const res = await getUserByIdentityDocNum("70515206");

  if (!res) return <p>no-data</p>;

  return (
    <div>
      <p>{JSON.stringify(res.data)}</p>
      <Link href="/" className="border p-2 bg-red-300">
        RETURN
      </Link>
    </div>
  );
};

export default page;
