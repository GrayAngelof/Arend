from fastapi import APIRouter

router = APIRouter(prefix="/buildings", tags=["buildings"])

@router.get("/tree")
async def get_buildings_tree():
    # Пока заглушка — потом заменим на реальный запрос к БД
    return {
        "complex": "Markoff Complex",
        "buildings": [
            {
                "id": 1,
                "name": "Корпус А",
                "floors": [
                    {"floor": 1, "rooms": ["101", "102"]},
                    {"floor": 2, "rooms": ["201", "202", "203"]}
                ]
            },
            {
                "id": 2,
                "name": "Корпус Б",
                "floors": [
                    {"floor": -1, "rooms": ["B-01"]},
                    {"floor": 3, "rooms": ["301"]}
                ]
            }
        ]
    }