use("ecomart");

// Query 1 optimization
db.groceries.createIndex({ Member_number: 1 });

db.groceries.aggregate([
  { $sort: { Member_number: 1 } },
  { $group: { _id: "$Member_number", recordedItemCount: { $sum: 1 } } },
  { $sort: { recordedItemCount: -1 } },
  { $limit: 10 }
]);

// Query 2 optimization
db.cosmetics.createIndex({ Combination: 1, Rank: -1 });

db.cosmetics.find({ Combination: 1 })
  .sort({ Rank: -1, Name: 1 })
  .limit(10);

// Query 3: preserve the original ingredient query's full result set.
// This unanchored substring search can still require scanning ingredient text.
// Adding a rating condition changes the business question; it is not an
// equivalent-query optimization.
db.cosmetics.find({
  Ingredients: { $regex: "Butylene Glycol", $options: "i" }
}).sort({ Rank: -1, Name: 1 });

// Separate business variant: retain only products rated at least 4.
// The full ingredient search returns 772 products; this variant returns 574.
db.cosmetics.find({
  Rank: { $gte: 4 },
  Ingredients: { $regex: "Butylene Glycol", $options: "i" }
}).sort({ Rank: -1, Name: 1 });
