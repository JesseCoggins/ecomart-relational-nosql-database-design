use("D597Task2");

// Query 1 optimization
db.groceries.createIndex({ Member_number: 1 });

db.groceries.aggregate([
  { $sort: { Member_number: 1 } },
  { $group: { _id: "$Member_number", totalPurchases: { $sum: 1 } } },
  { $sort: { totalPurchases: -1 } },
  { $limit: 10 }
]);

// Query 2 optimization
db.cosmetics.createIndex({ Combination: 1, Rank: -1 });

db.cosmetics.find({ Combination: 1 })
  .sort({ Rank: -1, Name: 1 })
  .limit(10);

// Query 3 optimization
// Regex search is not index-friendly for substring matching, so reduce the scan set first.
db.cosmetics.find({
  Rank: { $gte: 4 },
  Ingredients: { $regex: "Butylene Glycol", $options: "i" }
}).sort({ Rank: -1, Name: 1 });
