const { MongoClient } = require("mongodb");

// Connection URI (adjust as needed)
const uri = "mongodb://localhost:27017";
const client = new MongoClient(uri);

async function flipAndLogValues() {
  try {
    await client.connect();

    // Define the database and collection
    const database = client.db("integrator");
    const collection = database.collection("gcaches");

    // Find all documents with a boolean 'value' field
    const documents = await collection.find({ value: { $type: "bool" } }).toArray();

    for (const doc of documents) {
      const beforeValue = doc.value;
      const afterValue = !beforeValue;  // Flipped value

      // Print the document ID and before/after values
      console.log(`MS key: ${doc.key}`);
      console.log(`Before: ${beforeValue}, After: ${afterValue}`);

      // Update the document's 'value' field with the flipped value
      await collection.updateOne({ _id: doc._id }, { $set: { value: afterValue } });
    }
  } catch (error) {
    console.error("Error updating documents:", error);
  } finally {
    await client.close();
  }
}

flipAndLogValues();
