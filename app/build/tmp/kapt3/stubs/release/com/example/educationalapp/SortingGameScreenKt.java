package com.example.educationalapp;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u0000N\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0000\u001aX\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00010\u00072\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00010\u00072\u0018\u0010\t\u001a\u0014\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00010\nH\u0007\u00f8\u0001\u0000\u00a2\u0006\u0004\b\f\u0010\r\u001a$\u0010\u000e\u001a\u00020\u00012\u0006\u0010\u000f\u001a\u00020\u00102\u0012\u0010\u0011\u001a\u000e\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u00010\u0012H\u0007\u001a(\u0010\u0014\u001a\u00020\u00012\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u000b2\u0006\u0010\u0018\u001a\u00020\u000b2\u0006\u0010\u0019\u001a\u00020\u000bH\u0007\u001a\u001e\u0010\u001a\u001a\u00020\u00012\u0006\u0010\u0015\u001a\u00020\u00162\f\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u000b0\u001cH\u0007\u001a\u000e\u0010\u001d\u001a\b\u0012\u0004\u0012\u00020\u00030\u001eH\u0002\u0082\u0002\u0007\n\u0005\b\u00a1\u001e0\u0001\u00a8\u0006\u001f"}, d2 = {"DraggableItem", "", "item", "Lcom/example/educationalapp/SortableItem;", "position", "Landroidx/compose/ui/geometry/Offset;", "onDragStart", "Lkotlin/Function0;", "onDragEnd", "onPositionChange", "Lkotlin/Function2;", "", "DraggableItem-YqVAtuI", "(Lcom/example/educationalapp/SortableItem;JLkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function2;)V", "DropTarget", "category", "Lcom/example/educationalapp/ItemCategory;", "onBoundsChanged", "Lkotlin/Function1;", "Landroidx/compose/ui/geometry/Rect;", "SortingGameHeader", "navController", "Landroidx/navigation/NavController;", "score", "total", "sorted", "SortingGameScreen", "starState", "Landroidx/compose/runtime/MutableState;", "generateItems", "", "app_release"})
public final class SortingGameScreenKt {
    
    @androidx.compose.runtime.Composable()
    public static final void SortingGameScreen(@org.jetbrains.annotations.NotNull()
    androidx.navigation.NavController navController, @org.jetbrains.annotations.NotNull()
    androidx.compose.runtime.MutableState<java.lang.Integer> starState) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void SortingGameHeader(@org.jetbrains.annotations.NotNull()
    androidx.navigation.NavController navController, int score, int total, int sorted) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void DropTarget(@org.jetbrains.annotations.NotNull()
    com.example.educationalapp.ItemCategory category, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super androidx.compose.ui.geometry.Rect, kotlin.Unit> onBoundsChanged) {
    }
    
    private static final java.util.List<com.example.educationalapp.SortableItem> generateItems() {
        return null;
    }
}