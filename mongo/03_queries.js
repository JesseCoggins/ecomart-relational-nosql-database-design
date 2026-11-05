use("ecomart");

// Business question: Which grocery members have the most recorded item purchases?
// 1. Member activity: count item records, not distinct shopping visits
db.groceries.aggregate([
  { $sort: { Member_number: 1 } },
  { $group: { _id: "$Member_number", recordedItemCount: { $sum: 1 } } },
  { $sort: { recordedItemCount: -1 } },
  { $limit: 10 }
]);

// Business question: Which high-ranked cosmetics are suitable for combination skin?
// 2. High-ranked cosmetics suitable for combination skin
db.cosmetics.find({ Combination: 1 })
  .sort({ Rank: -1, Name: 1 })
  .limit(10);

// Business question: Which products contain Butylene Glycol, ordered by rating?
// 3. Cosmetics containing a trending ingredient
db.cosmetics.find({
  Ingredients: { $regex: "Butylene Glycol", $options: "i" }
}).sort({ Rank: -1, Name: 1 });
